# Security policy

## Supported versions

Only the latest commit on `main` gets security fixes.

## Reporting a vulnerability

Please do not open a public issue for security problems. Report them privately
through GitHub: open the
[Security tab](https://github.com/medaminben/Pendulum/security) and choose
**Report a vulnerability**
([direct link](https://github.com/medaminben/Pendulum/security/advisories/new)).

Include what is affected, how to reproduce it, and what an attacker could do
with it. You should get an answer within a week. Once a fix is released, the
advisory is published and you are credited unless you prefer not to be.

Pendulum downloads GoogleTest at configure time and uses the Qt installed on
your system. Problems in those projects belong with their maintainers. If
Pendulum pins a vulnerable version, report that here.
