package tk.whitephilosophy.courcework1;

/**
 * Created by kirill on 12/10/16.
 */
public interface UserRequestHandler {
    void handleUserRequest(String request, String subject, String[] params);
}
