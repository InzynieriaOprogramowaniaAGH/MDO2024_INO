# Zajęcia 06
---

## Pipeline: lista kontrolna
Oceń postęp prac na pipelinem

### Ścieżka krytyczna
Podstawowy zbiór czynności do wykonania w ramach zadania z pipelinem CI/CD. Ścieżką krytyczną jest:
- [ ] commit (lub manual trigger @ Jenkins)
- [ ] clone
- [ ] build
- [ ] test
- [ ] deploy
- [ ] publish

Poniższe czynności wykraczają ponad tę ścieżkę, ale zrealizowanie ich pozwala stworzyć pełny, udokumentowany, jednoznaczny i łatwy do utrzymania pipeline z niskim progiem wejścia dla nowych *maintainerów*.

### Pełna lista kontrolna
Zweryfikuj dotychczasową postać sprawozdania oraz planowane czynności względem ścieżki krytycznej oraz poniższej listy. Realizacja punktu wymaga opisania czynności, wykazania skuteczności (screen), podania poleceń i uzasadnienia decyzji dot. implementacji.

- [ ] Aplikacja została wybrana
- [ ] Licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania
- [ ] Wybrany program buduje się
- [ ] Przechodzą dołączone do niego testy
- [ ] Zdecydowano, czy jest potrzebny fork własnej kopii repozytorium
- [ ] Stworzono diagram UML zawierający planowany pomysł na proces CI/CD
- [ ] Wybrano kontener bazowy lub stworzono odpowiedni kontener wstepny (runtime dependencies)
- [ ] Build został wykonany wewnątrz kontenera
- [ ] Testy zostały wykonane wewnątrz kontenera
- [ ] Kontener testowy jest oparty o kontener build
- [ ] Logi z procesu są odkładane jako numerowany artefakt
- [ ] Zdefiniowano kontener 'deploy' służący zbudowanej aplikacji do pracy
- [ ] Uzasadniono czy kontener buildowy nadaje się do tej roli/opisano proces stworzenia nowego
- [ ] Wersjonowany kontener 'deploy' ze zbudowaną aplikacją jest wdrażany na instancję Dockera
- [ ] Następuje weryfikacja, że aplikacja pracuje poprawnie (*smoke test*)
- [ ] Zdefiniowano, jaki element ma być publikowany jako artefakt
- [ ] Uzasadniono wybór: kontener z programem, plik binarny, flatpak, archiwum tar.gz, pakiet RPM/DEB
- [ ] Opisano proces wersjonowania artefaktu (można użyć *semantic versioning*)
- [ ] Dostępność artefaktu: publikacja do Rejestru online, artefakt załączony jako rezultat builda w Jenkinsie
- [ ] Przedstawiono sposób na zidentyfikowanie pochodzenia artefaktu
- [ ] Pliki Dockerfile i Jenkinsfile dostępne w sprawozdaniu w kopiowalnej postaci oraz obok sprawozdania, jako osobne pliki
- [ ] Zweryfikowano potencjalną rozbieżność między zaplanowanym UML a otrzymanym efektem
- [ ] Sprawozdanie pozwala zidentyfikować cel podjętych kroków
- [ ] Forma sprawozdania umożliwia wykonanie opisanych kroków w jednoznaczny sposób
