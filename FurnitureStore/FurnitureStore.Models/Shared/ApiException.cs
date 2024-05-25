using System.Net;

namespace FurnitureStore.Models.Shared
{
    public class ApiException : CustomException
    {
        public ApiException(string message, HttpStatusCode code)
            : base(message, code)
        {

        }
    }
}
