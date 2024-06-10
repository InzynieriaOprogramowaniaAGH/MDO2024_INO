FROM nginx:latest

RUN echo '<h1> Kiedy obserwujemy gwiazdy, obraz, który widzimy, tak naprawdę pochodzi sprzed wielu lat: tylu, o ile lat świetlnych oddalona jest od nas dana gwiazda. Jeśli gwiazda oddalona jest od ziemi o 50 lat świetlnych, to oznacza, że światło potrzebuje 50 lat by do nas dotrzeć: czyli, oglądamy jej obraz sprzed 50 lat. W rzeczywistości gwiazda może wyglądać zupełnie inaczej, lub nawet nie istnieć. Działa to oczywiście również w drugą stronę. Z niektórych miejsc w kosmosie widać ziemię sprzed wielu lat. Oznacza to, że z miejsca w kosmosie oddalonego od ziemi o 604 lata świetlne, można na żywo obejrzeć Bitwę pod Grunwaldem.</h1>' > /usr/share/nginx/html/index.html

EXPOSE 80