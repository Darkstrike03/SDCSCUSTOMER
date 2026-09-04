-- ============================================================
-- SDCS Customer App — customer_data table
-- Run this in Supabase SQL Editor (Dashboard → SQL Editor → New query)
-- ============================================================

-- 1. Create the table
create table if not exists public.customer_data (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text not null default '',
  email       text not null default '',
  phone       text,
  avatar_url  text,
  background_url text,
  addresses   jsonb not null default '[]'::jsonb,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- 2. Auto-update updated_at on change
create or replace function public.update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists customer_data_updated_at on public.customer_data;
create trigger customer_data_updated_at
  before update on public.customer_data
  for each row execute function public.update_updated_at();

-- 3. Auto-create a customer_data row when a user signs up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.customer_data (id, full_name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    new.email
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 4. Row Level Security — users can only read/update their own data
alter table public.customer_data enable row level security;

drop policy if exists "Users can view own customer_data" on public.customer_data;
create policy "Users can view own customer_data"
  on public.customer_data for select
  using (auth.uid() = id);

drop policy if exists "Users can update own customer_data" on public.customer_data;
create policy "Users can update own customer_data"
  on public.customer_data for update
  using (auth.uid() = id);

-- 5. Grant access to the authenticated role
grant select, update on public.customer_data to authenticated;
