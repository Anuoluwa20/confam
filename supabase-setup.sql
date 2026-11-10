-- Confam: run once in Supabase → SQL Editor → New query → Run.
-- Safe to run again: it only adds what is missing.

create table if not exists public.submissions (
  id uuid primary key default gen_random_uuid(),
  type text not null,
  key text not null,
  shown text not null,
  why text, text text, contact text,
  status text not null default 'pending',
  created_at timestamptz not null default now()
);
alter table public.submissions add column if not exists amount text;
alter table public.submissions add column if not exists name text;
alter table public.submissions add column if not exists paid_on date;
alter table public.submissions add column if not exists proof_path text;
alter table public.submissions add column if not exists proof_checked boolean not null default false;
alter table public.submissions add column if not exists agreed boolean not null default false;

alter table public.submissions drop constraint if exists submissions_type_check;
alter table public.submissions add constraint submissions_type_check check (type in ('report','praise','reply'));
alter table public.submissions drop constraint if exists submissions_status_check;
alter table public.submissions add constraint submissions_status_check check (status in ('pending','approved','rejected'));
alter table public.submissions drop constraint if exists submissions_sizes;
alter table public.submissions add constraint submissions_sizes check (
  char_length(key) between 8 and 80 and char_length(shown) <= 80 and coalesce(char_length(why),0) <= 80
  and coalesce(char_length(text),0) <= 600 and coalesce(char_length(contact),0) <= 120 and coalesce(char_length(amount),0) <= 20 and coalesce(char_length(name),0) <= 60);
create index if not exists submissions_key_status on public.submissions (key, status);

alter table public.submissions enable row level security;

-- The website may only ADD rows: always pending, never pre-checked, always agreed.
-- A report must carry proof, the amount and the date (enforced here, not just in the form).
drop policy if exists "website can submit" on public.submissions;
create policy "website can submit" on public.submissions for insert to anon
  with check (
    status = 'pending' and proof_checked = false and agreed = true
    and (type <> 'report' or (proof_path is not null and amount is not null and paid_on is not null
         and paid_on <= current_date and paid_on > current_date - 366 and char_length(coalesce(contact,'')) >= 6))
  );

-- What the website can read: approved rows only. No contact, no proof file.
drop view if exists public.reports_public;
create view public.reports_public as
  select id, type, key, shown, name, why, text, amount, paid_on, proof_checked, created_at
  from public.submissions where status = 'approved';
grant select on public.reports_public to anon;

-- Private bucket for proof screenshots: the website can upload, nobody can read them but you.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('proofs','proofs', false, 5242880, array['image/png','image/jpeg','image/webp'])
on conflict (id) do nothing;
drop policy if exists "website can upload proofs" on storage.objects;
create policy "website can upload proofs" on storage.objects for insert to anon
  with check (bucket_id = 'proofs');
