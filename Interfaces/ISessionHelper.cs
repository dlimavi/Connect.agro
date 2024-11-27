using Connect.Agro.Models.Domain;

namespace Connect.Agro.Web.Interfaces;

public interface ISessionHelper
{
    public void CreateSession(User user);

    public User? SearchSession();

    public void DeleteSession();
    
}
