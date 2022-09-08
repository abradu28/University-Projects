package butelca.transport.repository;

import butelca.transport.model.Transport;

import java.util.ArrayList;
import java.util.Date;

public class TransportRepository
{
    private int lastId;
    private ArrayList<Transport> transports;

    public TransportRepository()
    {
        transports = new ArrayList<>();
        lastId = 0;
    }

    public void addTransport()
    {
        transports.add(new Transport(lastId++));
    }

    public void removeTransportByID(int id)
    {
        for(Transport t : transports)
            if(t.getTransportID() == id) {
                transports.remove(t);
                break;
            }
    }

    public ArrayList<Transport> getTransportsByDate(Date d)
    {
        ArrayList<Transport> res = new ArrayList<>();
        for(Transport t : transports)
            if(t.getTransportDate().equals(d)) {
                res.add(t);
                break;
            }
        return res;
    }

    public Transport getTransportById(int id)
    {
        for(Transport t : transports)
            if(t.getTransportID() == id) {
                return t;
            }
        return null;
    }

    public ArrayList<Transport> getTransports() {
        return transports;
    }
}
