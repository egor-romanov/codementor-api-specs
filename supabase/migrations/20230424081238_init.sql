-- domains table is used to store the domains in the company
create table if not exists "public"."domains" (
  "id" uuid not null default uuid_generate_v4(),
  "name" text not null,
  "created_at" timestamptz not null default now(),
  "updated_at" timestamptz not null default now(),
  "deleted_at" timestamptz null,
  primary key ("id")
);
create unique index if not exists "domains_name_key" on "public"."domains" ("name");
alter table "public"."domains" enable row level security;
create policy "domains_authenticated_policy" on "public"."domains" to "authenticated" using (true);