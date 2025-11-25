import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import tailwindcss from "@tailwindcss/vite";
import path from "node:path";

// https://vite.dev/config/
export default defineConfig({
  base: "./",
  plugins: [svelte(), tailwindcss()],
  resolve: {
    alias: {
      "@app": path.resolve(__dirname, "src"),
      "@shared": path.resolve(__dirname, "../shared"),
    },
  },
  server: {
    fs: {
      allow: [".."],
    },
  },
  build: {
    outDir: path.resolve(__dirname, "../source/view"),
    emptyOutDir: true,
    assetsDir: ".",
    rollupOptions: {
      output: {
        entryFileNames: "js/script.js",
        assetFileNames: (chunkInfo) =>
          chunkInfo.names.some((n) => n.endsWith(".css"))
            ? "css/style.css"
            : "[name]-[hash][extname]",
      },
    },
  },
});
