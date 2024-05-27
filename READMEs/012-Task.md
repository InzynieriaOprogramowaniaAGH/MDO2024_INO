# *Shift-left*: GitHub Actions
## Zadania do wykonania
 - Zapoznaj się z koncepcją GitHub Actions
   https://docs.github.com/en/actions
 - Zwróć szczególną uwagę na trigger, omawiany na zajęciach
 - Cennik do przeczytania (ze zrozumieniem!!):
   https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions
 - **Darmowy plan** powinien wystarczyć przynajmniej do zdefiniowania przykładu
 - Sforkuj repozytorium z wybranym oprogramowaniem. **Nie commituj pipeline'ów do głównego projektu!!**
 - Stwórz akcję przeprowadzającą build na podstawie *kontrybucji* do dedykowanej gałęzi `ino_dev`
  - Usuń obecne w projekcie *workflows*, jeżeli istnieją
  - Utwórz własną akcję reagującą na zmianę w `ino_dev`
  - Zweryfikuj, że wybrany program buduje się wewnątrz Akcji po zacommitowaniu zmiany do gałęzi
  - Jeżeli build jest zbyt duży, zmodyfikuj akcję aby wykonywała inną czynność
 
