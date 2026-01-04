using Google.Apis.Auth;

namespace DeboAlertApi.Security
{
    public static class FirebaseTokenValidator
    {
        public static async Task<GoogleJsonWebSignature.Payload> ValidateAsync(string token)
        {
            return await GoogleJsonWebSignature.ValidateAsync(token);
        }
    }
}
