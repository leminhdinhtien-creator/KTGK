using System;
using System.Security.Cryptography;
using System.Text;
using Abp.Authorization;

namespace MyCompany.MyProject.Toeic;

public static class ReadingSession
{
    public static string Hash(string key)
    {
        if (key == null || key.Length != 64 || !System.Text.RegularExpressions.Regex.IsMatch(key,"^[a-f0-9]{64}$"))
            throw new AbpAuthorizationException("Phiên thi không hợp lệ. Mở lại ứng dụng để tạo phiên mới.");
        return Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(key)));
    }
    public static bool Matches(string key,string hash)
    {
        if (hash == null || hash.Length != 64) return false;
        return CryptographicOperations.FixedTimeEquals(Encoding.ASCII.GetBytes(Hash(key)),Encoding.ASCII.GetBytes(hash));
    }
}
