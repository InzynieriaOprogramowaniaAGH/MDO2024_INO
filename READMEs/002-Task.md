# Zajęcia 02

---

# Git, Docker

- Wykonaj opisane niżej kroki i dokumentuj ich wykonanie
- Zastosuj się do wytycznych z [poprzednich zajęć](./001-Task.md)

- Sprawozdanie proszę umieścić w następującej ścieżce: ```<kierunek>/<grupa>/<inicjały><numerIndeksu>/Sprawozdanie1/README.md```, w formacie Markdown

## Zadania do wykonania

## Zestawienie środowiska

1. Zainstaluj Docker w systemie linuksowym
2. Zarejestruj się w [Docker Hub](https://hub.docker.com/) i zapoznaj z sugerowanymi obrazami
3. Pobierz obrazy `hello-world`, `busybox`, `ubuntu` lub `fedora`, `mysql`
4. Uruchom kontener z obrazu `busybox`
   - Pokaż efekt uruchomienia kontenera
   - Podłącz się do kontenera **interaktywnie** i wywołaj numer wersji
5. Uruchom "system w kontenerze" (czyli kontener z obrazu `fedora` lub `ubuntu`)
   - Zaprezentuj `PID1` w kontenerze i procesy dockera na hoście
   - Zaktualizuj pakiety
   - Wyjdź
6. Stwórz własnoręcznie, zbuduj i uruchom prosty plik `Dockerfile` bazujący na wybranym systemie i sklonuj nasze repo.
   - Kieruj się [dobrymi praktykami](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
   - Upewnij się że obraz będzie miał `git`-a
   - Uruchom w trybie interaktywnym i zweryfikuj że jest tam ściągnięte nasze repozytorium
7. Pokaż uruchomione ( != "działające" ) kontenery, wyczyść je.
8. Wyczyść obrazy
9. Dodaj stworzone pliki `Dockefile` do folderu swojego `Sprawozdanie1` w repozytorium.
10. Wystaw *Pull Request* do gałęzi grupowej jako zgłoszenie wykonanego zadania.