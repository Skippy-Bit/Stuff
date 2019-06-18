import 'dart:math';

int lcs(String s1, String s2) => s1.length + s2.length - 2 * _length(s1, s2);

/// Returns the length of Longest Common Subsequence (LCS) between strings [s1] and [s2].
int _length(String s1, String s2) {
  int m = s1.length;
  int n = s2.length;
  List<int> x = s1.codeUnits;
  List<int> y = s2.codeUnits;

  List<List<int>> c =
      new List<List<int>>(m + 1).map((_) => new List<int>(n + 1)).toList();

  for (var i = 0; i <= m; i++) {
    c[i][0] = 0;
  }

  for (var j = 0; j <= n; j++) {
    c[0][j] = 0;
  }

  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      if (x[i - 1] == y[j - 1]) {
        c[i][j] = c[i - 1][j - 1] + 1;
      } else {
        c[i][j] = max(c[i][j - 1], c[i - 1][j]);
      }
    }
  }

  return c[m][n];
}

@override
double normalizedLcs(String s1, String s2) {
  int maxLength = max(s1.length, s2.length);
  if (maxLength == 0) {
    return 0.0;
  }
  return 1.0 - (_length(s1, s2) / maxLength);
}
