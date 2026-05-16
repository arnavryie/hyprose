# Contributing to Hyprose

Thank you for your interest in Hyprose! This is a community-driven Arch Linux distribution featuring Hyprland and end-4's dotfiles.

## How to Contribute

### Reporting Bugs
- Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.md)
- Include ISO version, GPU model, and installation method
- Attach `/tmp/hyprose-install.log` if installation failed

### Suggesting Features
- Use the [Feature Request template](.github/ISSUE_TEMPLATE/feature_request.md)
- Check if the feature aligns with Hyprose's goals (easy Hyprland ricing)

### Code Contributions
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-thing`
3. Make your changes
4. Test locally with `mkarchiso`
5. Submit a Pull Request

### Areas Needing Help
- **GPU Support**: NVIDIA Optimus, hybrid graphics testing
- **Translations**: Calamares installer translations
- **Documentation**: Wiki articles, video tutorials
- **Themes**: Additional color schemes for the Quickshell widgets

## Development Setup

```bash
# Build the ISO locally
sudo pacman -S archiso
cd hyprose
sudo mkarchiso -v -w /tmp/hyprose-work .

# Test in QEMU
qemu-system-x86_64 -m 4G -cdrom out/*.iso
```

## Code of Conduct
- Be respectful and inclusive
- Focus on constructive feedback
- Help newcomers learn

## License
By contributing, you agree that your contributions will be licensed under GPL-3.0.
