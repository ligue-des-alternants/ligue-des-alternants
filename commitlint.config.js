export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat', // Nouvelle fonctionnalité
        'fix', // Correction de bug
        'docs', // Documentation
        'style', // Formatage, missing semi colons, etc
        'refactor', // Refactoring de code
        'perf', // Amélioration des performances
        'test', // Ajout de tests
        'chore', // Maintenance
        'ci', // CI/CD
        'build', // Build system
        'revert', // Revert d'un commit précédent
      ],
    ],
    'subject-case': [2, 'never', ['upper-case']],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'type-empty': [2, 'never'],
  },
};
