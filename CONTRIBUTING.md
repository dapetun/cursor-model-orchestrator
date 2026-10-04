# Contributing

Thanks for contributing to **cursor-model-orchestrator**.

## License

Contributions are accepted under the [MIT License](LICENSE) (inbound = outbound).

## Developer Certificate of Origin (DCO)

This project uses the [Developer Certificate of Origin](https://developercertificate.org/).

Every commit must include a sign-off trailer:

```text
Signed-off-by: Your Name <your@email.example>
```

Create signed-off commits with:

```bash
git commit -s -m "Your message"
```

Fix a missing sign-off:

- single commit: `git commit --amend -s` (then force-push your branch if already pushed)
- several commits: `git rebase --signoff <base>`

By signing off you certify that you wrote the change or have the right to submit it under this project's license, and that the contribution and its record are public.

Existing history before this policy is grandfathered; new commits on PRs must be signed off. CI fails the PR if a sign-off is missing.

## Pull requests

1. Fork / branch from `main`.
2. Keep changes focused (routing policy, skill text, configs, docs).
3. Do **not** commit secrets, real user prompts, or personal data.
4. Open a PR; fill the template (DCO checkbox + summary).

## Privacy invariant (do not break)

When changing Hindsight / stack logging behaviour:

- Never retain full user prompts, source code, file contents, secrets, or PII.
- Retain only the lean `orchestrator_route` / `orchestrator_budget` fields documented in [docs/hindsight-schema.md](docs/hindsight-schema.md).

## Trademark

See [NOTICE](NOTICE). Do not imply endorsement by Cursor, Anthropic, OpenAI, Google, xAI, or other model vendors.

## Questions

Open a GitHub issue. Legal / commercial questions: see [docs/legal/](docs/legal/).
