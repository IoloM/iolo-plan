-- Iolo's Planner: cloud state storage.
--
-- One private row per account holding the whole planner state as JSON.
-- Row Level Security means a signed-in user can only ever read/write THEIR OWN row,
-- so the public page + publishable key can never expose one person's data to another.
-- The first account ever created becomes the owner; after that, sign-ups are refused
-- (this is a single-user app — just Iolo, across his devices).

create extension if not exists pgcrypto with schema extensions;

-- ---------------------------------------------------------------- owner gate
create table if not exists public.plan_owner (
  user_id uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table public.plan_owner enable row level security;
create policy "owner sees self" on public.plan_owner
  for select to authenticated using (user_id = (select auth.uid()));

-- refuse a second sign-up; first sign-up claims ownership
create or replace function public.plan_guard_signup()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if exists (select 1 from public.plan_owner) then
    raise exception 'Sign-ups are closed.';
  end if;
  return new;
end $$;

create or replace function public.plan_claim_owner()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not exists (select 1 from public.plan_owner) then
    insert into public.plan_owner (user_id) values (new.id);
  end if;
  return new;
end $$;

drop trigger if exists plan_guard_signup on auth.users;
create trigger plan_guard_signup before insert on auth.users
  for each row execute function public.plan_guard_signup();

drop trigger if exists plan_claim_owner on auth.users;
create trigger plan_claim_owner after insert on auth.users
  for each row execute function public.plan_claim_owner();

-- ---------------------------------------------------------------- state
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
