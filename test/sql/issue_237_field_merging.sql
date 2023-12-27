begin;
    -- https://github.com/supabase/pg_graphql/issues/237
    create table blog_post(
        id int primary key,
        a text,
        b text,
        c text,
        d text,
        e text,
        f text
    );
    insert into public.blog_post
    values (1, 'a', 'b', 'c', 'd', 'e', 'f');
    select jsonb_pretty(
      graphql.resolve($$
        query {
          blogPostCollection {
            edges {
              node {
                a
                ...c_query
                ... @include(if: true) {
                  e
                }
              }
            }
          }
          blogPostCollection {
            edges {
              node {
                b
                ...d_query
                ... @include(if: true) {
                  f
                }
              }
            }
          }
        }

        fragment c_query on BlogPost {
          c
        }

        fragment d_query on BlogPost {
          d
        }
      $$)
    );
rollback;
