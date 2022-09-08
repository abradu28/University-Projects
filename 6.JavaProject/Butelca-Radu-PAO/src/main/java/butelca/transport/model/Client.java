package butelca.transport.model;

public class Client extends Person
{
    public Client(int id, String firstName, String lastName, String phoneNumber) {
        super(id, firstName, lastName, phoneNumber);
    }

    @Override
    public String toString() {
        return "Client " + super.toString();
    }
}
