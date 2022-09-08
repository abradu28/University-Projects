package butelca.transport.service;

import butelca.transport.model.Client;
import butelca.transport.repository.ClientRepository;

import java.util.Scanner;

public class ClientService
{
    private ClientRepository clientRepository;
    private AuditService auditService;

    public ClientService()
    {
        clientRepository = new ClientRepository();
        auditService = AuditService.getAuditService();
    }

    public Client addClient(Scanner s)
    {
        System.out.println("Enter first name: ");
        String first_name = s.next();

        System.out.println("Enter last name: ");
        String last_name = s.next();

        System.out.println("Enter phone number: ");
        String phone_nr = s.next();

        Client c = new Client(clientRepository.getLast_id(), first_name, last_name, phone_nr);
        clientRepository.addClient(c);

        auditService.logData("ClientService_addClient");
        return c;
    }

    public void removeClient(Scanner s)
    {
        System.out.println("Enter client ID: ");
        clientRepository.removeClient(s.nextInt());

        auditService.logData("ClientService_removeClient");
    }

    public Client getClientById(int id)
    {
        auditService.logData("ClientService_getClientById");

        return clientRepository.getClientById(id);
    }



    public String allClients()
    {
        auditService.logData("ClientService_allClients");

        StringBuilder res = new StringBuilder();
        for(Client c : clientRepository.getClients())
        {
            res.append(c.toString()).append("\n");
        }
        return res.toString();
    }

    public ClientRepository getClientRepository() {
        return clientRepository;
    }
}
