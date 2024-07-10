begin;

    create table public.works(
        work_id int primary key
    );

    create table public.readthroughs (
        readthrough_id int primary key,
        work_id int not null references public.works(work_id),
        status text not null
    );

    select jsonb_pretty(
      graphql.resolve($$
        {
          __type(name: "Works") {
            kind
            fields {
              name
              type {
                kind
                name
              }
            }
          }
        }
      $$)
    );

    /* Creating partial unique referencing status should NOT change the relationship with
    the readthroughs to a non-null unique because its partial and other statuses may
    have multiple associated readthroughs */
    create unique index idx_unique_in_progress_readthrough
      on public.readthroughs (work_id)
      where status in ('in_progress');

    select jsonb_pretty(
        graphql.resolve($$
        {
          __type(name: "Works") {
            kind
            fields {
              name
              type {
                kind
                name
              }
            }
          }
        }
        $$)
    );

rollback;
