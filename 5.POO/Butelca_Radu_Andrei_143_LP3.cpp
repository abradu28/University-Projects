#include <bits/stdc++.h>

// Alegem ca clasa de baza clasa IO realizata pentru inputuri si outputuri
// Abstracta pt ca nu este nevoie sa fie initializata
// Clasa inspirata din tutorialul de poo, care la randul ei a fost inspirata de la lobarotistul de anul trecut
using namespace std;

class IO {
public:
    virtual ~IO() {}

    friend istream &operator>>(istream &in, IO &io) {
        io.citeste(in);
        return in;
    }

    friend ostream &operator<<(ostream &out, const IO &io) {
        io.afiseaza(out);
        return out;
    }

    virtual void citeste(istream &) = 0;

    virtual void afiseaza(ostream &) const = 0;
};


//clasa ajutatoare pentru verificarea de inputuri
class Helper {
public:

    static int este_cuvant(string cuvant)
    {
        for (int i = 0; i < cuvant.size(); i++)
        {
            int litera = toupper(cuvant[i]); //Convert character to upper case version of character
            if (litera < 'A' || litera > 'Z') //If character is not A-Z
            {
                return 0;
            }
        }

        return 1;
    }


    static unsigned int alege_tip(istream &, string, vector<string>);
};

unsigned int Helper::alege_tip(istream &in, string obiect, vector<string> optiuni) {
    string optiune = "";

    bool first = false;
    bool cond = false;
    unsigned int result;

    do {
        if (first) {
            cout << "Optiune invalida." << endl;
            cout << "Optiunile valide: " << endl;
            for (int i = 0; i < optiuni.size(); i++)
                cout << optiuni[i] << endl;
        }
        cout << "Alegeti tipul de " << obiect << ":" << endl;
        in >> optiune;
        first = true;

        for (unsigned int i = 0; i < optiuni.size(); i++)
            if (equal(optiune.begin(), optiune.end(),
                      optiuni[i].begin(), optiuni[i].end(),
                      [](char a, char b) {
                          return toupper(a) == toupper(b);
                      })) {
                cond = true;
                result = i;
            }
    } while (!cond);

    return result;
}

//inceperea problemei
class Animal : public IO {
protected:
    string denumire;
    string habitat;
    int nr_specii_existente;

    long long animale_descoperite = 1525728;
public:
    Animal() = default;

    Animal(string denumire, string habitat, int nr_specii_existente) {
        this->denumire = denumire;
        this->habitat = habitat;
        this->nr_specii_existente = nr_specii_existente;
    }

    Animal &operator=(const Animal &animal) {
        if (this == &animal)
            return *this;
        denumire = animal.denumire;
        habitat = animal.habitat;
        nr_specii_existente = animal.nr_specii_existente;
    }

    Animal(const Animal &animal) {
        *this = animal;
    }

    ~Animal() {
        denumire.clear();
        habitat.clear();
    }

    void citeste(istream &in) override {
        int ok = 1;
        while(ok){
            cout << "Introdu denumirea:";
            cin >> denumire;
            try {
                if(!Helper::este_cuvant(denumire))
                    throw denumire;
                ok = 0;

            }
            catch(string denumire){
                cout << "nu e buna\n";

            }
        }

        vector<string> habitate = {"acvatic", "terestru", "aerian"};
        int tip_habitat = Helper::alege_tip(in, "habitat", habitate);
        habitat = habitate[tip_habitat];
        ok = 1;
        while(ok) {
            try {
                cout << "Introdu nr de specii: ";
                in >> nr_specii_existente;
                if(nr_specii_existente < 1)
                    throw(nr_specii_existente);
                ok = 0;
            }
            catch (int nr_specii_existente){
                cout << "Valoarea introdusa trebuie sa fie pozitiva\n";
            }
        }
    }

    void afiseaza(ostream &out) const override {
        out << "Denumirea este:" << denumire << endl;
        out << "Habitatul este:" << habitat << endl;
        out << "Numarul de specii este:" << nr_specii_existente << endl;
    }

    const string &getDenumire() const;

    const string &getHabitat() const;

    int getNrSpeciiExistente() const;

// functie apelata doar in cazuri extraordinare cum ar fi descoperirea unei noi specii de animale

    void descoperire() const{
        (long long int) const_cast<Animal *>(this)->animale_descoperite++;
    }
};

const string &Animal::getDenumire() const {
    return denumire;
}

const string &Animal::getHabitat() const {
    return habitat;
}

int Animal::getNrSpeciiExistente() const {
    return nr_specii_existente;
}




class Vertebrate : public Animal {
protected:
    bool prezenta_falci;
public:
    Vertebrate() = default;

    Vertebrate(bool prezenta_falci, string denumire, string habitat, int nr_specii_existente) :
            Animal(denumire, habitat, nr_specii_existente) {
        this->prezenta_falci = prezenta_falci;
    }

    Vertebrate &operator=(const Vertebrate &vertebrate) {
        if (this == &vertebrate)
            return *this;
        Animal::operator=(vertebrate);
        prezenta_falci = vertebrate.prezenta_falci;
    }

    Vertebrate(const Vertebrate &vertebrate) {
        *this = vertebrate;
    }

    ~Vertebrate() = default;

    void citeste(istream &in) override {
        Animal::citeste(in);
        int ok = 1;
        while(ok) {
            try{
            cout << "Prezenta falcilor: 0 sau 1";
            in >> prezenta_falci;
            if(prezenta_falci < 0 || prezenta_falci >1)
                throw(prezenta_falci);
            ok = 0;
            }
            catch(bool prezenta_falci){
                cout << "Valoarea trebuie sa fie 1 sau 0\n";
            }
        }

    }

    void afiseaza(ostream &out) const override {
        Animal::afiseaza(out);
        if (prezenta_falci) out << "Are falci" << endl;
        else
            out << "Nu are falci " << endl;
    }

    bool isPrezentaFalci() const {
        return prezenta_falci;
    }

};

class Pesti : public Vertebrate {
    string tip_schelet;
    double lungime;
    bool rapitor;
public:
    ~Pesti() {
        tip_schelet.clear();
        lungime = 0;
        rapitor = false;
    }

    Pesti() = default;

    Pesti(string tip_schelet, double lungime, bool rapitor, bool prezenta_falci, string denumire, string habitat,
          int nr_specii_existente) :
            Vertebrate(prezenta_falci, denumire, habitat, nr_specii_existente) {
        this->tip_schelet = tip_schelet;
        this->lungime = lungime;
        this->rapitor = rapitor;
    }

    Pesti &operator=(const Pesti &pesti) {
        if (this == &pesti)
            return *this;
        Vertebrate::operator=(pesti);
        tip_schelet = pesti.tip_schelet;
        lungime = pesti.lungime;
        rapitor = pesti.rapitor;
    }

    Pesti(const Pesti &pesti) {
        *this = pesti;
    }

    void citeste(istream &in) override {
        Vertebrate::citeste(in);
        vector<string> tip_structura_osoasa = {"osos", "cartilaginos", "cartilaginos-osos"};
        int tip = Helper::alege_tip(in, "structura osoasa ", tip_structura_osoasa);
        tip_schelet = tip_structura_osoasa[tip];
        int ok = 1;
        while(ok) {
            try {
                cout << "Lungimea: ";
                in >> lungime;
                if(lungime < 0)
                    throw(lungime);
                ok = 0;
            }
            catch (double lungime){
                cout << "Valoarea introdusa trebuie sa fie strict pozitiva\n";
            }
        }
        ok = 1;
        while(ok){
            try{
                cout << "Este rapitor? 01:";
                in >> rapitor;
                if(rapitor < 0 && rapitor > 1)
                    throw rapitor;
                ok = 0;
            }
            catch(bool rapitor){
                cout << "Valoarea trebuie sa fie 0 sau 1 \n";
            }
        }

    }

    void afiseaza(ostream &out) const override {
        Vertebrate::afiseaza(out);
        out << "Tipul scheletului este: " << tip_schelet << endl;
        out << "Lungimea este: " << lungime << endl;
        if (rapitor)
            out << "Este rapitor" << endl;
        else
            out << "Nu este rapitor" << endl;
    }

     double getLungime() const {
        return lungime;
    }

    bool isRapitor() const {
        return rapitor;
    }

     const string &getTipSchelet() const {
        return tip_schelet;
    }
};

class Pasari : public Vertebrate {
    string mod_de_viata; // calatoare sau necalatoare
public:
    ~Pasari() {
        mod_de_viata.clear();
    }

    Pasari() = default;

    Pasari(string mod_de_viata, bool prezenta_falci, string denumire, string habitat, int nr_specii_existente) :
            Vertebrate(prezenta_falci, denumire, habitat, nr_specii_existente) {
        this->mod_de_viata = mod_de_viata;
    }

    Pasari &operator=(const Pasari &pasari) {
        if (this == &pasari)
            return *this;
        Vertebrate::operator=(pasari);
        mod_de_viata = pasari.mod_de_viata;

    }

    Pasari(const Pasari &pasari) {
        *this = pasari;
    }

    void citeste(istream &in) override {
        Vertebrate::citeste(in);
        vector<string> moduri = {"calatoare", "necalatoare"};
        int mod = Helper::alege_tip(in, "viata", moduri);
        mod_de_viata = moduri[mod];

    }

    void afiseaza(ostream &out) const override {
        Vertebrate::afiseaza(out);
        out << "Modul de viata este: " << mod_de_viata << endl;
    }

  const string &getModDeViata() const {
        return mod_de_viata;
    }

};

class Mamifere : public Vertebrate {
    string mod_de_hranire; // omnivor, erbivor, carnivor, insectivor
public:
    ~Mamifere() {
        mod_de_hranire.clear();
    }

    Mamifere() = default;

    Mamifere(string mod_de_hranire, bool prezenta_falci, string denumire, string habitat, int nr_specii_existente) :
            Vertebrate(prezenta_falci, denumire, habitat, nr_specii_existente) {
        this->mod_de_hranire = mod_de_hranire;
    }

    Mamifere &operator=(const Mamifere &mamifere) {
        if (this == &mamifere)
            return *this;
        Vertebrate::operator=(mamifere);
        mod_de_hranire = mamifere.mod_de_hranire;
    }

    Mamifere(const Mamifere &mamifere) {
        *this = mamifere;
    }

    void citeste(istream &in) override {
        Vertebrate::citeste(in);
        vector<string> moduri = {"omnivor", "erbivor", "carnivor", "insectivor"};
        int mod = Helper::alege_tip(in, "hranire", moduri);
        mod_de_hranire = moduri[mod];

    }

    void afiseaza(ostream &out) const override {
        Vertebrate::afiseaza(out);
        out << "Modul de hranire este: " << mod_de_hranire << endl;
    }

    const string &getModDeHranire() const {
        return mod_de_hranire;
    }

};

class Reptile : public Vertebrate {
    string culoare;
public:
    ~Reptile() {
        culoare.clear();
    }

    Reptile() = default;

    Reptile(string culoare, bool prezenta_falci, string denumire, string habitat, int nr_specii_existente) :
            Vertebrate(prezenta_falci, denumire, habitat, nr_specii_existente) {
        this->culoare = culoare;
    }

    Reptile &operator=(const Reptile &reptile) {
        if (this == &reptile)
            return *this;
        Vertebrate::operator=(reptile);
        culoare = reptile.culoare;
    }

    Reptile(const Reptile &reptile) {
        *this = reptile;
    }

    void citeste(istream &in) override {
        Vertebrate::citeste(in);

        int ok = 1;
        while(ok){
            cout << "Culoarea:";
            cin >> culoare;
            try {
                if(!Helper::este_cuvant(culoare))
                    throw culoare;
                ok = 0;

            }
            catch(string culoare){
                cout << "nu e buna\n";

            }
        }


    }

    void afiseaza(ostream &out) const override {
        Vertebrate::afiseaza(out);
        cout << "Culoarea: " << culoare << endl;
    }

    const string &getCuloare() const {
        return culoare;
    }

};

template<typename T>
class AtlasZoologic {
    list<Animal *> multime;
    int nr_animale;
public:
    //destructor
    ~AtlasZoologic(){
        while(multime.empty()){
            delete multime.front();
            multime.pop_front();
        }
    }
//constructor cu parametrii
    AtlasZoologic(const list<Animal *> &multime) : multime(multime) {}
//constructor de initializare
    AtlasZoologic() = default;
//operator =
    AtlasZoologic &operator=(const AtlasZoologic &atlas) {
        if (this == &atlas)
            return *this;
        for (auto &x : multime)
            this->x = *x;
    }
//cc
    AtlasZoologic(const AtlasZoologic &atlas) {
        *this = atlas;

    }

   // incrementarea ceruta
    AtlasZoologic<T> &operator+=(T *animal) {
        nr_animale++;
        multime.push_back(animal);
        return *this;
    }
   //decrementare
    AtlasZoologic<T> &operator--() {
        if (nr_animale > 0) {
            nr_animale--;
            multime.pop_back();
        }
        return *this;
    }
   //functie pentru afisarea continutului din lista
    void afisare_multime() {
        if (!multime.size())
            cout << "Atlasul este gol" << endl;
        else
            for (auto &x : multime)
            {  cout <<"Informatii animal:\n";
                cout << *x;}
    }
 //getter
    int getNrAnimale() const {
        return nr_animale;
    }

};

//functie template cu specializare explicita pentru pesti

template<>
class AtlasZoologic<Pesti> {

    list<Animal *> multime;
    static int nr_pesti;
    static int nr_pesti_rapitori;
public:
    //destructor
    ~AtlasZoologic(){
        while(multime.empty()){
            delete multime.front();
            multime.pop_front();
        }
    }
    //constructor fara parametri
    AtlasZoologic() = default;
 // op =
    AtlasZoologic& operator = (const AtlasZoologic& atlas){
        if(this == &atlas)
            return *this;
    }
    //constructor de copiere
    AtlasZoologic(const AtlasZoologic& atlas){
        this == &atlas;
    }
   //constructoor cu parametri
    AtlasZoologic(const list<Animal *> &multime);
  //incrementare
    AtlasZoologic<Pesti> &operator+=(Pesti *pesti) {
        nr_pesti++;
        multime.push_back(pesti);
        //functie in + pentru specializarea cu pesti
        if (pesti->isRapitor() && pesti->getLungime() >= 1)
            nr_pesti_rapitori++;
        return *this;
    }
    //decrementare
    AtlasZoologic<Pesti> &operator--() {
        if (nr_pesti > 0) {
            nr_pesti--;

            multime.pop_back();
        }

        return *this;
    }

    void afisare_multime() {
        if (!multime.size())
            cout << "Atlasul este gol" << endl;
        else {
            for (auto &x : multime)
            {  cout << "Informatii peste\n";
                cout << *x;}
            cout << "Numarul pestilor de vanatoare si cu lungimea mai mare de 1m din atlas este: " << nr_pesti_rapitori
                 << endl;
        }
    }

    static int getNrPesti()  {
        return nr_pesti;
    }

    static int getNrPestiRapitori();

};

int AtlasZoologic<Pesti> :: nr_pesti = 0;
int AtlasZoologic<Pesti> :: nr_pesti_rapitori = 0;

int AtlasZoologic<Pesti>::getNrPestiRapitori() {
    return nr_pesti_rapitori;
}

AtlasZoologic<Pesti>::AtlasZoologic(const list<Animal *> &multime) : multime(multime) {}

// clasa Menu singleton
// aceasta clasa a fost inspirata de la tuturialul de poo 2021
class Menu {
private:

    Menu();

    Menu(const Menu &) = delete;

    Menu &operator=(const Menu &) = delete;

public:

    void run();

public:

    static Menu *get_instance();

    static void delete_instance();

private:

    vector<pair<string, function<void()>>> _operatii;

private:

    static Menu *g_instance;
};

Menu *Menu::g_instance = nullptr;

void Menu::run() {
    bool running = true;

    while (running) {
        try {
            int op;

            cout << "Alege operatia" << endl;
            for (int i = 0; i < _operatii.size(); i++)
                cout << i << ") " << _operatii[i].first << endl;
            cout << _operatii.size() << ") Inchidere" << endl;

            cin >> op;
            if (op < 0 || op > _operatii.size())
                throw runtime_error("Optiune invalida");

            if (op == _operatii.size()) {
                running = false;
                continue;
            }

            _operatii[op].second();
        }
        catch (const exception &e) {
            cout << "Am intampinat o problema: " << e.what() << endl;
        }

    }
}

AtlasZoologic<Animal> atlas_zoo;
AtlasZoologic<Pesti> atlas_pesti;

Menu::Menu() {

    _operatii.push_back(make_pair("Adauga animal in atlasul de animale: ", [&]() {

        Animal *animal = new Animal();
        cin >> *animal;
        atlas_zoo += animal;

    }));
    _operatii.push_back(make_pair("Adauga pasare in atlasul de animale: ", [&]() {

        Animal *animal = new Pasari();
        cin >> *animal;
        atlas_zoo += animal;

    }));
    _operatii.push_back(make_pair("Adauga peste in atlasul de animale: ", [&]() {

        Animal *animal = new Pesti();
        cin >> *animal;
        atlas_zoo += animal;

    }));
    _operatii.push_back(make_pair("Adauga mamifer in atlasul de animale: ", [&]() {

        Animal *animal = new Mamifere();
        cin >> *animal;
        atlas_zoo += animal;

    }));
    _operatii.push_back(make_pair("Adauga reptila in atlasul de animale: ", [&]() {

        Animal *animal = new Reptile();
        cin >> *animal;
        atlas_zoo += animal;

    }));
    _operatii.push_back(make_pair("Adauga peste in atlasul de pesti: ", [&]() {
        Pesti *p = new Pesti();
        cin >> *p;
        atlas_pesti += p;

    }));
    _operatii.push_back(make_pair("Afiseaza atlasul zoologic: ", [&]() {
        atlas_zoo.afisare_multime();
    }));
    _operatii.push_back(make_pair("Afiseaza atlasul de pesti: ", [&]() {
        atlas_pesti.afisare_multime();
    }));
    _operatii.push_back(make_pair("Scoate ultimul animal introdus din atlasul de animale: ", [&]() {
        if (atlas_zoo.getNrAnimale() > 0)
            --atlas_zoo;
        else {
            cout << "Atlasul este gol, nu avem ce sa scoatem din el" << endl;
        }
    }));
    _operatii.push_back(make_pair("Scoate ultimul peste introdus din atlasul de pesti: ", [&]() {
        if (atlas_pesti.getNrPesti() > 0)
            --atlas_pesti;
        else {
            cout << "Atlasul este gol, nu avem ce sa scoatem din el" << endl;
        }
    }));

}

Menu *Menu::get_instance() {
    if (!g_instance)
        g_instance = new Menu();

    return g_instance;
}

void Menu::delete_instance() {
    delete g_instance;
    g_instance = nullptr;
}

using namespace std;

int main() {
   // utilizarea meniului singleton
    Menu::get_instance()->run();

   //dezalocarea memoriei
    Menu::delete_instance();


    return 0;
}
