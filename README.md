# Confam — check, praise or report online vendors

Buyers praise good vendors and report bad ones. A person approves every review.
Anyone can check an account number, phone or @handle before paying, vendors can
reply, and the "Ask Confam" assistant on the site answers from the same reviews.

## 1. Create the database (5 minutes, free)
1. Sign up at supabase.com and create a new project.
2. Open **SQL Editor → New query**, paste everything in `supabase-setup.sql`, press **Run**.

## 2. Connect the website
1. In Supabase open **Project Settings → API**.
2. Copy the **Project URL** and the **anon public** key.
3. Open `index.html`, search for `CONFAM SETTINGS`, paste both values between the quotes.
   Never paste the `service_role` key anywhere in the site.
4. Redeploy on Vercel (drag the folder in, or push to your repo).

Until step 2 is done, the site works but says "Confam reports are not switched on yet"
and the forms send nothing.

## 3. Approve experiences
Supabase → **Table Editor → submissions**. New rows arrive as `pending`. The `type` column says `praise`, `report` or `reply`.
Open the proof (Storage → proofs, the file named in `proof_path`). If it matches the
amount, date and story, tick `proof_checked` and set `status` to `approved`.
Otherwise set `rejected`. Approved rows show on the site at once. For vendor replies, use the `contact` column to confirm it is really
the business before approving. The contact never appears on the site.

## Good to know
- Account and phone numbers are never stored in full: the site saves a scrambled key
  and a masked version (012 •••• 789).
- Offer checks ("double your money…") use a built-in pattern checker. No AI, no cost.
- The three samples (@glowgadgets_demo, 0123456789, "Double your money in 30 days")
  always show sample results, labelled as samples.
- Before you open it to the public, get advice on Nigeria's Data Protection Act 2023
  and on defamation, since the site shows other people's accounts of vendors.

## How Confam keeps it honest
- Reports need proof (receipt or chat), the amount, the date and a private contact.
  The database itself refuses a report without them.
- Proof files sit in a private bucket. Only you can open them.
- Every experience waits as `pending` until a person approves it.
- One experience per vendor per buyer device for 30 days, plus a hidden bot trap.
- Vendors reply for free; their reply shows beside the report.
- Watch for bursts: several reports about one vendor in a short time, from new
  contacts, deserve a closer look before approving.
