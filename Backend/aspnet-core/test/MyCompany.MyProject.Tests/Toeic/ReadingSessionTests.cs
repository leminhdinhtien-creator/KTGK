using System;
using Abp.Authorization;
using MyCompany.MyProject.Toeic;
using Xunit;

namespace MyCompany.MyProject.Tests.Toeic;
public class ReadingSessionTests
{
    [Fact]
    public void SessionStoresHashAndRejectsOtherDeviceKey()
    {
        var key=new string('a',64);var hash=ReadingSession.Hash(key);
        Assert.NotEqual(key,hash);
        Assert.True(ReadingSession.Matches(key,hash));
        Assert.False(ReadingSession.Matches(new string('b',64),hash));
        Assert.False(ReadingSession.Matches(key,null));
    }
    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("123")]
    [InlineData("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")]
    public void MissingOrMalformedKeyCannotIdentifyAnAttempt(string key)
        => Assert.Throws<AbpAuthorizationException>(()=>ReadingSession.Hash(key));
}
