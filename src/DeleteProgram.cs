using System;
using System.Reflection;
using System.Windows.Forms;

[assembly: AssemblyTitle("Exclude China High-Ping Server - Delete")]
[assembly: AssemblyDescription("Removes the Windows Firewall rules created by ExcludeChinaHighPingServer.exe.")]
[assembly: AssemblyCompany("Community utility")]
[assembly: AssemblyProduct("ExcludeChinaHighPingServer_Delete")]
[assembly: AssemblyVersion("1.1.0.0")]
[assembly: AssemblyFileVersion("1.1.0.0")]

namespace ExcludeChinaHighPingServerTool
{
    internal static class DeleteProgram
    {
        [STAThread]
        private static void Main()
        {
            try
            {
                dynamic policy = FirewallRule.OpenPolicy();
                int removedCount = FirewallRule.RemoveAll(policy);

                MessageBox.Show(
                    removedCount > 0
                        ? "차단 규칙 " + removedCount + "개를 삭제했습니다.\n\n방화벽 설정이 원상복구되었습니다."
                        : "이 프로그램이 만든 차단 규칙이 없습니다.\n\n원상복구할 항목이 없습니다.",
                    "타르코프 중국 고핑 서버 차단 해제",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "방화벽 차단 규칙을 삭제하지 못했습니다.\n\n" + ex.Message,
                    "타르코프 중국 고핑 서버 차단 해제 - 오류",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error);
                Environment.ExitCode = 1;
            }
        }
    }
}
