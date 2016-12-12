package tk.whitephilosophy.courcework1;

import java.security.InvalidParameterException;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by kirill on 12/10/16.
 */
public interface DatabaseManager {
    void viewAll(String table) throws SQLException;
    void addOrder(String[] params) throws SQLException, InvalidParameterException;
    void updateCustomer(String field, int id, String value) throws SQLException;
    void deleteCustomer(String[] field) throws SQLException;
}
