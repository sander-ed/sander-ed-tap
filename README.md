# Private Homebrew tap

Homebrew formulae for `sander-ed` projects.

## Install Gnosis

Your GitHub account must have read access to both this repository and
[`sander-ed/gnosis`](https://github.com/sander-ed/gnosis). Configure a GitHub SSH
key before installing.

```sh
brew tap sander-ed/tap ssh://git@github.com/sander-ed/homebrew-tap.git
brew install sander-ed/tap/gnosis
gnosis --help
```

Gnosis supports macOS and Linux. The formula builds from the private source
repository over SSH, pinned to a version tag and commit. Homebrew installs Rust
for the build and Git for runtime use. No tokens or prebuilt binaries are
published by this tap.

## Upgrade

```sh
brew update
brew upgrade sander-ed/tap/gnosis
```

## Publish a new version

Bump `[package].version` in the Gnosis `Cargo.toml`, refresh `Cargo.lock` with
Cargo, and push to the source repository's `main` branch.

The source repository's **Update Homebrew tap** GitHub Actions workflow checks
each push. If the version differs from the formula, it tests and builds the
release commit, creates a `vVERSION` tag, and commits the updated `tag` and
`revision` to this tap. Unchanged versions are skipped. Users receive releases
through `brew update` and `brew upgrade`.

To retry a failed publication, run the workflow manually in
[`sander-ed/gnosis`](https://github.com/sander-ed/gnosis/actions/workflows/homebrew.yml).
Existing tags are reused, never moved. Queued runs use the latest source `main`
to avoid publishing stale versions.

The workflow authenticates with a dedicated write-enabled deploy key on this
tap, stored as the source repository's `HOMEBREW_TAP_DEPLOY_KEY` Actions secret.
If rotating it, replace both the deploy key here and that secret.

## Troubleshooting

If `gnosis` still runs an older Cargo installation, check `which gnosis`.
`~/.cargo/bin/gnosis` may precede Homebrew in your `PATH`. The Homebrew binary is
`$(brew --prefix)/bin/gnosis`; adjust your `PATH` if you want it to take precedence.

On managed networks, Cargo may report a self-signed certificate in the chain.
Use a PEM CA bundle containing your organization's trusted root certificates
and the standard public roots, obtained from your administrator. Do not disable
TLS verification. Homebrew 7 filters ordinary environment variables, so pass
the bundle into the build process explicitly:

```sh
HOMEBREW_GNOSIS_CA_BUNDLE=/absolute/path/to/trusted-ca-bundle.pem \
  brew ruby -e '
    ENV["CARGO_HTTP_CAINFO"] = ENV.fetch("HOMEBREW_GNOSIS_CA_BUNDLE")
    exec "/bin/bash", "#{HOMEBREW_LIBRARY}/Homebrew/brew.sh",
         "install", "sander-ed/tap/gnosis"
  '
```

Use `"upgrade"` instead of `"install"` for subsequent upgrades on that network.
This setting applies only to that command; it does not change system trust or
store certificates in the formula.
