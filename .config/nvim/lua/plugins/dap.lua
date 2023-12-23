local nmap = require("rizhiy.keys").nmap
local dap_map = function(key, func, desc, opts)
    opts = opts or {}
    if desc ~= nil then desc = "DAP: " .. desc end
    opts.desc = desc
    nmap(key, func, opts)
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "Weissle/persistent-breakpoints.nvim", opts = { load_breakpoints_event = { "BufReadPost" } } },
            { "rcarriga/nvim-dap-ui", opts = {} },
        },
        config = function()
            local dap = require("dap")
            dap_map("<F9>", dap.continue, "Start/Continue")
            dap_map("<F10>", dap.step_over, "Step Over")
            dap_map("<F11>", dap.step_into, "Step Into")
            dap_map("<F12>", dap.step_out, "Step Out")

            local pb = require("persistent-breakpoints.api")
            dap_map("<leader>db", pb.toggle_breakpoint, "Toggle breakpoint")
            dap_map(
                "<leader>dg",
                function() pb.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
                "Set conditional breakpoint"
            )
            dap_map(
                "<leader>di",
                function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
                "Set log point"
            )
            dap_map("<leader>dB", pb.clear_all_breakpoints, "Toggle breakpoint")
            dap_map("<leader>dr", dap.repl.open, "Open REPL")

            local dapui = require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

            dap_map("<leader>dx", function()
                dap.disconnect()
                dap.terminate()
                dap.close()
                dapui.close()
            end, "Exit")

            vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointSymbol" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointSymbol" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpointSymbol" })
            vim.fn.sign_define("DapLogPoint", { text = "", texthl = "GruvboxBlue" })
            vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStoppedSymbol" })
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        dependencies = { "mfussenegger/nvim-dap" },
        ft = { "python" },
        config = function()
            local dap_python = require("dap-python")
            dap_python.setup("~/miniconda3/bin/python")
            dap_python.test_runner = "pytest"

            dap_map("<leader>dm", dap_python.test_method, "Test method")
            dap_map("<leader>dc", dap_python.test_class, "Test class")
        end,
    },
}
