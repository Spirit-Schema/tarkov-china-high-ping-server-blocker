using System;
using System.Reflection;
using System.Windows.Forms;

[assembly: AssemblyTitle("Exclude China High-Ping Server")]
[assembly: AssemblyDescription("Blocks three suspected Escape from Tarkov high-ping server IPs using Windows Firewall.")]
[assembly: AssemblyCompany("Community utility")]
[assembly: AssemblyProduct("ExcludeChinaHighPingServer")]
[assembly: AssemblyVersion("1.1.0.0")]
[assembly: AssemblyFileVersion("1.1.0.0")]

namespace ExcludeChinaHighPingServerTool
{
    internal static class BlockProgram
    {
        [STAThread]
        private static void Main()
        {
            try
            {
                dynamic policy = FirewallRule.OpenPolicy();
                FirewallRule.AddOrReplace(policy);

                MessageBox.Show(
                    "타르코프 고핑 의심 서버 3개를 차단했습니다.\n\n" +
                    String.Join("\n", FirewallRule.Addresses) + "\n\n" +
                    "같은 파일을 다시 실행해도 규칙이 중복 생성되지 않습니다.",
                    "타르코프 중국 고핑 서버 차단",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "방화벽 차단 규칙을 만들지 못했습니다.\n\n" + ex.Message,
                    "타르코프 중국 고핑 서버 차단 - 오류",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
                Environment.ExitCode = 1;
            }
        }
    }
}
