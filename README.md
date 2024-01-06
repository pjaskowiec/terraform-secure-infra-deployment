main.tf: contains all providers, resources and data sources
variables.tf: contains all defined variables
output.tf: contains all output resources

<!-- 3) [4 pkt] Stwórz	skrypt	Terraform,	umożliwiający	dostarczenie	następującej	infrastruktury.
a) Bastion	 host,	 za	 pomocą	 którego	 może	 odbywać	 się	 ręczna	 konfiguracja	 fragmentów	
systemu.
b) Maszyna	EC2,	na	której	znajdować	ma	się	aplikacja.
c) Autoscaling	group,	skalujący	maszyny	z	aplikacją.
d) Application	Load	balancer,	który	będzie	kierował	ruch	do	tych	maszyn.
e) Baza	danych	w	RDS,	w	której	przechowywane	są	dane	aplikacji.
f) Odpowiednie	reguły	dostępowe,	tj.
i) Dostęp	po	SSH	wyłącznie	do	bastion	hosta;
ii) Bastion	host	może	mieć	dostęp	do	dowolnej	usługi;
iii) Do	bazy	dostęp	ma	wyłącznie	aplikacja;
iv) Do	aplikacji	jest	dostęp ze	świata na	wybranym	porcie -->