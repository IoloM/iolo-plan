-- Iolo's Planner: cloud state storage.
--
-- One private row per account holding the whole planner state as JSON.
-- Row Level Security means a signed-in user can only ever read/write THEIR OWN row,
-- so the public page + publishable key can never expose one person's data to another.
--
-- This reuses the existing Supabase project (shared with Daily Verse), whose
-- auth already holds Iolo's account and has sign-ups closed. So there is no new
-- owner gate here — RLS on auth.uid() is all that's needed. Iolo signs in with
-- his existing account and gets his own planner row.

create table if not exists public.plan_state (
  user_id uuid primary key references auth.users (id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.plan_state enable row level security;

create policy "read own state"   on public.plan_state
  for select to authenticated using (user_id = (select auth.uid()));
create policy "insert own state" on public.plan_state
  for insert to authenticated with check (user_id = (select auth.uid()));
create policy "update own state" on public.plan_state
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
