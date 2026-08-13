using System;
using System.Reflection;
using System.Windows.Forms;

[assembly: AssemblyTitle("Exclude China High-Ping Server")]
[assembly: AssemblyDescription("Blocks the confirmed Escape from Tarkov high-ping server IP using Windows Firewall.")]
[assembly: AssemblyCompany("Community utility")]
[assembly: AssemblyProduct("ExcludeChinaHighPingServer")]
[assembly: AssemblyVersion("1.1.1.0")]
[assembly: AssemblyFileVersion("1.1.1.0")]

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
                    "고핑이 확인된 타르코프 서버 1개를 차단했습니다.\n\n" +
                    String.Join("\n", FirewallRule.Addresses) + "\n\n" +
                    "이전 버전의 관찰 후보 규칙 2개가 있으면 제거했습니다.\n\n" +
                    "이 서버에 배정되어 접속 오류가 뜨면 재접속하지 말고 '나가기 확인'을 누르세요.",
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
