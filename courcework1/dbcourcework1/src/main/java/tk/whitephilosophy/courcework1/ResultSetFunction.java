package tk.whitephilosophy.courcework1;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by kirill on 12/11/16.
 */
public interface ResultSetFunction {
    void process(ResultSet rs) throws SQLException;
}
