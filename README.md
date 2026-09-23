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

1. Bump `version` in the Gnosis `Cargo.toml`, refresh `Cargo.lock` with Cargo,
   run `cargo test --locked`, and commit and push the changes.
2. Tag that source commit as `vVERSION` and push the tag to `sander-ed/gnosis`.
   Do not move existing release tags.
3. Update `tag` and `revision` in `Formula/gnosis.rb` to the new tag and its full
   commit SHA (`git rev-parse vVERSION^{commit}` in the source checkout).
4. In a checkout of this tap, run `brew style Formula/gnosis.rb`. Install the
   updated formula with `brew reinstall --build-from-source sander-ed/tap/gnosis`
   from the local Homebrew tap checkout, then run `brew test sander-ed/tap/gnosis`.
5. Commit and push the formula change. Users receive it through `brew update`
   and `brew upgrade`.

The installed tap checkout is located at `brew --repository sander-ed/tap`.
Make release edits there, or copy the changed formula there before testing.
Release updates are manual; pushing application changes alone does not upgrade
the Homebrew package.

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
