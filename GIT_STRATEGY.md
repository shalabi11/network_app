# Git Commit Strategy

## Commit History Plan

This document outlines the commit strategy for the Network App project.

## Branch Strategy

- `main` - Production-ready code
- `develop` - Development branch
- `feature/*` - Feature branches
- `bugfix/*` - Bug fix branches
- `hotfix/*` - Urgent fixes

## Commit Messages

Following [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

## Planned Commits

### Phase 1: Project Setup
1. `chore: initialize Flutter project with Clean Architecture structure`
2. `chore: add dependencies for BLoC, DI, networking, and UI`
3. `feat: create core utilities, constants, and error handling`

### Phase 2: Core Features
4. `feat: implement theme management with light/dark modes`
5. `feat: add multilingual support (English and Arabic)`
6. `feat: create dependency injection setup with GetIt`
7. `feat: implement network info and connectivity monitoring`

### Phase 3: Domain Layer
8. `feat(towers): create cellular tower entity and network stats`
9. `feat(towers): define tower repository interface`
10. `feat(towers): implement get nearby towers use case`
11. `feat(towers): implement ping tower use case`

### Phase 4: Data Layer
12. `feat(towers): create cellular tower model with JSON serialization`
13. `feat(towers): implement remote data source with Dio`
14. `feat(towers): implement local data source with Hive`
15. `feat(towers): implement tower repository with offline support`

### Phase 5: State Management
16. `feat(towers): create tower BLoC with events and states`
17. `feat(settings): create theme Cubit for theme management`
18. `feat(settings): create language Cubit for language switching`
19. `feat(settings): create settings Cubit for app preferences`

### Phase 6: UI Components
20. `feat(ui): create reusable loading shimmer component`
21. `feat(ui): create empty state widget`
22. `feat(ui): create error widget with retry functionality`
23. `feat(ui): create tower card component`

### Phase 7: Main Screens
24. `feat(splash): implement splash screen with animation`
25. `feat(onboarding): add onboarding flow for first-time users`
26. `feat(home): create home screen with bottom navigation`
27. `feat(map): implement map view with Google Maps integration`
28. `feat(list): create tower list view with expandable details`
29. `feat(settings): implement settings screen with preferences`

### Phase 8: Permissions & Configuration
30. `feat(permissions): add location permission handling`
31. `feat(permissions): configure Android permissions in manifest`
32. `feat(permissions): configure iOS permissions in Info.plist`
33. `feat(config): add assets configuration for images and animations`

### Phase 9: Testing
34. `test(towers): add unit tests for get nearby towers use case`
35. `test(towers): add BLoC tests for tower state management`
36. `test: add mock generators for testing`

### Phase 10: Documentation
37. `docs: create comprehensive README with project overview`
38. `docs: add ARCHITECTURE.md explaining Clean Architecture implementation`
39. `docs: add SETUP.md with installation and configuration guide`
40. `docs: document commit strategy in GIT_STRATEGY.md`

### Phase 11: Future Enhancements (To Be Implemented)
41. `feat(notifications): implement push notifications with Firebase`
42. `feat(background): add background network monitoring`
43. `feat(stats): implement real-time network statistics`
44. `feat(analytics): integrate Firebase Analytics`
45. `feat(crashlytics): add crash reporting`

## Git Commands for Committing

```bash
# Initial commit (after completing all features)
git init
git add .
git commit -m "chore: initialize Flutter project with Clean Architecture"

# Add remote
git remote add origin https://github.com/shalabi11/network_app.git

# Push to main branch
git push -u origin main

# For subsequent commits
git add <files>
git commit -m "<type>(<scope>): <message>"
git push origin main
```

## Example Commits

```bash
# Feature commit
git commit -m "feat(towers): implement map view with cellular towers

- Add Google Maps integration
- Display towers with color-coded markers
- Show tower details on marker tap
- Add user location tracking"

# Bug fix commit
git commit -m "fix(map): correct marker color for inaccessible towers

Previously, inaccessible towers were showing green markers.
Changed to red markers as per requirements."

# Refactoring commit
git commit -m "refactor(towers): extract tower card into reusable component

- Move tower card logic to separate widget
- Make component reusable across screens
- Add customization options"

# Documentation commit
git commit -m "docs: update README with setup instructions

- Add installation steps
- Include API key configuration
- Add troubleshooting section"
```

## Best Practices

1. **Commit Often**: Make small, logical commits
2. **Descriptive Messages**: Clearly explain what and why
3. **Test Before Commit**: Ensure code works
4. **Use Branches**: Don't commit directly to main
5. **Review Changes**: Use `git diff` before committing
6. **Atomic Commits**: Each commit should be self-contained

## Pre-Commit Checklist

- [ ] Code compiles without errors
- [ ] Tests pass (`flutter test`)
- [ ] Code is formatted (`flutter format`)
- [ ] No linting errors (`flutter analyze`)
- [ ] Documentation updated if needed
- [ ] Commit message follows conventions

## GitHub Workflow

1. Create feature branch: `git checkout -b feature/map-view`
2. Make changes and commit: `git commit -m "feat(map): ..."`
3. Push branch: `git push origin feature/map-view`
4. Create Pull Request on GitHub
5. Review and merge to main
6. Delete feature branch

## Tags for Releases

```bash
# Create tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tags
git push origin --tags
```

## Useful Git Commands

```bash
# View commit history
git log --oneline --graph --all

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# View changes
git status
git diff

# Stash changes
git stash
git stash pop
```
