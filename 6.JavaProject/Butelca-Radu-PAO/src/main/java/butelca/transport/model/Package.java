package butelca.transport.model;

public class Package
{
    private int packageID;
    private float volume, weight;
    private City from,to;
    private Client owner;

    public Package(int packageID, float volume, float weight, City from, City to, Client owner) {
        this.packageID = packageID;
        this.volume = volume;
        this.weight = weight;
        this.from = from;
        this.to = to;
        this.owner = owner;
    }

    public int getPackageID() {
        return packageID;
    }

    public float getVolume() {
        return volume;
    }

    public void setVolume(float volume) {
        this.volume = volume;
    }

    public float getWeight() {
        return weight;
    }

    public void setWeight(float weight) {
        this.weight = weight;
    }

    public City getFrom() {
        return from;
    }

    public void setFrom(City from) {
        this.from = from;
    }

    public City getTo() {
        return to;
    }

    public void setTo(City to) {
        this.to = to;
    }

    public Client getOwner() {
        return owner;
    }

    public void setOwner(Client client) {
        this.owner = client;
    }

    @Override
    public String toString() {
        return  "Package" +
                " volume: " + volume +
                " weight:" + weight +
                " from:" + from.getName() +
                " to:" + to.getName() +
                " owner ID:" + owner.getId();
    }
}
