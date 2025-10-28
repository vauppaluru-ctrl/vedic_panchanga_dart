# Publishing vedic_panchanga_dart to pub.dev

## Pre-Publication Checklist

✅ Package structure created
✅ All source files copied and organized
✅ pubspec.yaml configured
✅ README.md with comprehensive documentation
✅ CHANGELOG.md created
✅ LICENSE file (AGPL-3.0) added
✅ Example code created
✅ Tests written
✅ Code formatted with `dart format`
✅ Analysis passes with 0 warnings
✅ Dry-run successful

## Before Publishing

### 1. Update GitHub URLs in pubspec.yaml

Replace the placeholder URLs in `pubspec.yaml`:

```yaml
homepage: https://github.com/YOUR_USERNAME/vedic_panchanga_dart
repository: https://github.com/YOUR_USERNAME/vedic_panchanga_dart
issue_tracker: https://github.com/YOUR_USERNAME/vedic_panchanga_dart/issues
```

### 2. Create GitHub Repository

1. Create a new repository on GitHub: `vedic_panchanga_dart`
2. Initialize git and push:

```bash
cd /Users/aria/Documents/FlutterApps/panchangAPI/vedic_panchanga_dart
git init
git add .
git commit -m "Initial release v0.1.0"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/vedic_panchanga_dart.git
git push -u origin main
```

### 3. Create Release Tag

```bash
git tag v0.1.0
git push origin v0.1.0
```

## Publishing to pub.dev

### Step 1: Authenticate with pub.dev

If you haven't already, log in to pub.dev:

```bash
dart pub login
```

This will open a browser for authentication.

### Step 2: Final Dry Run

```bash
cd /Users/aria/Documents/FlutterApps/panchangAPI/vedic_panchanga_dart
dart pub publish --dry-run
```

Verify that everything looks correct.

### Step 3: Publish

```bash
dart pub publish
```

Confirm when prompted.

## Post-Publication

### 1. Verify on pub.dev

Visit https://pub.dev/packages/vedic_panchanga_dart to see your package live.

### 2. Add Badge to README

The pub.dev badge will automatically work once published.

### 3. Monitor Package Health

Check the package score and health metrics on pub.dev. Aim for:
- 130+ pub points
- All platforms supported
- Good documentation score

## Future Updates

For releasing new versions:

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md` with new changes
3. Commit changes
4. Create a new git tag (e.g., `v0.2.0`)
5. Run `dart pub publish`

## Version Guidelines

Follow semantic versioning:
- **Major** (1.0.0): Breaking changes
- **Minor** (0.1.0): New features, backward compatible
- **Patch** (0.1.1): Bug fixes, backward compatible

## Package Maintenance

- Respond to issues on GitHub
- Keep dependencies updated
- Maintain documentation
- Add more features from PyJHora roadmap

## Notes

- The package uses AGPL-3.0 license (same as PyJHora)
- Credit PyJHora and PVR Narasimha Rao in all documentation
- Keep the port aligned with PyJHora updates when possible

## Support

If you encounter any issues during publishing:
- Check pub.dev publishing guide: https://dart.dev/tools/pub/publishing
- Review pub.dev policy: https://pub.dev/policy
- Contact pub.dev support if needed
