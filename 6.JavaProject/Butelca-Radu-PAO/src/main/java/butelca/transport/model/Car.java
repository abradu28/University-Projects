package butelca.transport.model;

public class Car implements Comparable
{
    private String registrationNr;
    private float volume;
    private Route route;

    public Car(String registration_nr, float volume, Route route) {
        if(registration_nr == null)
            throw new NullPointerException();
        this.registrationNr = registration_nr;
        this.volume = volume;
        this.route = route;
    }

    public String getRegistrationNr() {
        return registrationNr;
    }

    public void setRegistrationNr(String registrationNr) {
        this.registrationNr = registrationNr;
    }

    public float getVolume() {
        return volume;
    }

    public void setVolume(float volume) {
        this.volume = volume;
    }

    public Route getRoute() {
        return route;
    }

    public void setRoute(Route route) {
        this.route = route;
    }

    @Override
    public String toString() {
        return "Car: "+ registrationNr +
                " Volume: " + volume +
                " Route: " + (route == null ? "No route" : route.toString());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Car car = (Car) o;

        return registrationNr.equals(car.registrationNr);
    }

    @Override
    public int compareTo(Object o) {
        Car c = (Car) o;
        return registrationNr.compareTo(c.registrationNr);
    }
}
