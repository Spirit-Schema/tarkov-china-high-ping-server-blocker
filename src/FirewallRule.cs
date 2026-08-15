// Copyright © 2026 Spirit-Schema. All rights reserved.
// Licensed under the Tarkov Server Guard Source-Available Freeware License 1.0.

using System;

namespace ExcludeChinaHighPingServerTool
{
    internal static class FirewallRule
    {
        internal static readonly string[] Addresses =
        {
            "209.58.188.216"
        };

        private static readonly string[] LegacyAddresses =
        {
            "209.58.190.117",
            "209.58.191.183"
        };

        private const string RuleNamePrefix = "EFT_ExcludeChinaHighPingServer_";
        private const int NetFwActionBlock = 0;
        private const int NetFwRuleDirectionOutbound = 2;
        private const int NetFwIpProtocolAny = 256;
        private const int NetFwProfileAll = Int32.MaxValue;

        internal static dynamic OpenPolicy()
        {
            Type policyType = Type.GetTypeFromProgID("HNetCfg.FwPolicy2");
            if (policyType == null)
            {
                throw new InvalidOperationException("Windows Firewall is not available on this computer.");
            }

            return Activator.CreateInstance(policyType);
        }

        internal static string GetRuleName(string address)
        {
            return RuleNamePrefix + address;
        }

        internal static bool Exists(dynamic policy, string ruleName)
        {
            // Rules.Item(name) can throw HRESULT 0x80070002 when the rule does not
            // exist on some Windows builds. Enumeration treats that normal state
            // as a clean "not found" result.
            foreach (dynamic existingRule in policy.Rules)
            {
                string existingName = existingRule.Name as string;
                if (String.Equals(existingName, ruleName, StringComparison.OrdinalIgnoreCase))
                {
                    return true;
                }
            }

            return false;
        }

        internal static void AddOrReplace(dynamic policy)
        {
            // Also remove the two candidates used by v1.1.0 so running this
            // version upgrades an existing installation to the single-IP rule.
            RemoveAll(policy);

            try
            {
                foreach (string address in Addresses)
                {
                    Add(policy, address);
                }
            }
            catch
            {
                // Do not leave a partially applied set if creating a rule fails.
                RemoveAll(policy);
                throw;
            }
        }

        private static void Add(dynamic policy, string address)
        {
            Type ruleType = Type.GetTypeFromProgID("HNetCfg.FWRule");
            if (ruleType == null)
            {
                throw new InvalidOperationException("Windows Firewall rule support is not available.");
            }

            dynamic rule = Activator.CreateInstance(ruleType);
            rule.Name = GetRuleName(address);
            rule.Description =
                "Blocks outbound traffic to the Escape from Tarkov high-ping server " + address +
                ". Created by ExcludeChinaHighPingServer.exe.";
            rule.Direction = NetFwRuleDirectionOutbound;
            rule.Action = NetFwActionBlock;
            rule.Protocol = NetFwIpProtocolAny;
            rule.RemoteAddresses = address;
            rule.Profiles = NetFwProfileAll;
            rule.Enabled = true;

            policy.Rules.Add(rule);
        }

        internal static int RemoveAll(dynamic policy)
        {
            int removedCount = 0;
            removedCount += RemoveAddresses(policy, Addresses);
            removedCount += RemoveAddresses(policy, LegacyAddresses);
            return removedCount;
        }

        private static int RemoveAddresses(dynamic policy, string[] addresses)
        {
            int removedCount = 0;

            foreach (string address in addresses)
            {
                if (RemoveIfPresent(policy, GetRuleName(address)))
                {
                    removedCount++;
                }
            }

            return removedCount;
        }

        private static bool RemoveIfPresent(dynamic policy, string ruleName)
        {
            if (!Exists(policy, ruleName))
            {
                return false;
            }

            policy.Rules.Remove(ruleName);
            return true;
        }
    }
}
