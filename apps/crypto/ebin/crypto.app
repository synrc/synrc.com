{application, crypto,
   [{description, "CRYPTO"},
    {vsn, "3.6"},
    {modules, [crypto,crypto_ec_curves]},
    {registered, []},
    {applications, [kernel, stdlib]},
    {env, []},
    {runtime_dependencies, ["erts-6.0","stdlib-2.0","kernel-3.0"]}]}.
