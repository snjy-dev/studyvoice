with open('lib/features/reader/presentation/screens/reader_screen.dart', 'r', encoding='utf-8') as f:
    code = f.read()

bad = """                  },
                ),
              ),
            ),
          ),

          // Bottom Control Bar"""

good = """                  },
                ),
              ),
            ),
          ),
        ),

          // Bottom Control Bar"""

code = code.replace(bad, good)

with open('lib/features/reader/presentation/screens/reader_screen.dart', 'w', encoding='utf-8') as f:
    f.write(code)

print("Fixed")
