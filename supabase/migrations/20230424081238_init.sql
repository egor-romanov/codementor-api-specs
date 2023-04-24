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

-- user_domains table is used to store information about the users and the domains they belong to
create table if not exists "public"."user_domains" (
  "id" uuid not null default uuid_generate_v4(),
  "user_id" uuid not null,
  "domain_id" uuid not null,
  "created_at" timestamptz not null default now(),
  "updated_at" timestamptz not null default now(),
  primary key ("id")
);
create unique index if not exists "user_domains_user_id_domain_id_key" on "public"."user_domains" ("user_id", "domain_id");
alter table "public"."user_domains" add constraint "user_domains_user_id_fkey" foreign key ("user_id") references "auth"."users" ("id") on delete cascade;
alter table "public"."user_domains" add constraint "user_domains_domain_id_fkey" foreign key ("domain_id") references "public"."domains" ("id") on delete cascade;

alter table "public"."user_domains" enable row level security;
create policy "user_domains_user_id_policy" on "public"."user_domains" for select using (auth.uid() = "user_id");

