-- RESTRICTED VIEWS
REVOKE ALL ON TABLE public."responder_source_names" FROM "{{name}}";

REVOKE ALL ON TABLE public."responder_domain_names" FROM "{{name}}";

-- RESTRICTED TABLE PERMISSIONS
REVOKE ALL ON TABLE "restricted"."responses" FROM "{{name}}";

REVOKE ALL ON SCHEMA "restricted" FROM "{{name}}";
