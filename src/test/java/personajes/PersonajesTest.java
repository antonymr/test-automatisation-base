package personajes;

import com.intuit.karate.junit5.Karate;

public class PersonajesTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    @Karate.Test
    Karate testBasic() {
        return Karate.run("classpath:personajes/personajes.feature");
    }
}