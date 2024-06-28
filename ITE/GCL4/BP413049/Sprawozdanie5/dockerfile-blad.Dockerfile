# Wybierz obraz bazowy
FROM benishhh/spring:error

# Polecenie, które zostanie uruchomione przy starcie kontenera
CMD ["bash", "-c", "exit 1"]
