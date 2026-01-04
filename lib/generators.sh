#!/bin/bash

# Generates configuration files and source code based on selected features.

write_vite_config() {
  local ext="js"
  if $IS_TS; then ext="ts"; fi
  
  cat > "vite.config.$ext" <<EOF
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
EOF
}

write_tailwind_config() {
  if ! $USE_TAILWIND; then return; fi

  cat > tailwind.config.js <<EOF
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: 'var(--color-primary-50)',
          100: 'var(--color-primary-100)',
          500: 'var(--color-primary-500)',
          600: 'var(--color-primary-600)',
          900: 'var(--color-primary-900)',
        },
        background: 'var(--color-background)',
        text: 'var(--color-text)',
      },
    },
  },
  plugins: [],
}
EOF

  cat > postcss.config.js <<EOF
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
}

write_eslint_config() {
  if ! $USE_ESLINT; then
     # Even if no ESLint, we might want Prettier
     if $USE_PRETTIER; then
       cat > .prettierrc <<EOF
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
EOF
     fi
     return
  fi

  local config_content=""
  
  if $IS_TS; then
    config_content="import js from '@eslint/js'
import pluginVue from 'eslint-plugin-vue'
import globals from 'globals'
import typescript from '@vue/eslint-config-typescript'
"
    if $USE_PRETTIER; then config_content="${config_content}import configPrettier from '@vue/eslint-config-prettier'
"; fi

    config_content="${config_content}
export default [
  { ignores: ['dist', 'node_modules'] },
  js.configs.recommended,
  ...pluginVue.configs['flat/recommended'],
  ...typescript(),
"
  else
    config_content="import js from '@eslint/js';
import pluginVue from 'eslint-plugin-vue';
import globals from 'globals';
"
    if $USE_PRETTIER; then config_content="${config_content}import configPrettier from '@vue/eslint-config-prettier'
"; fi
    
    config_content="${config_content}
export default [
  { ignores: ['dist', 'node_modules'] },
  js.configs.recommended,
  ...pluginVue.configs['flat/recommended'],
"
  fi

  if $USE_PRETTIER; then
     config_content="${config_content}  configPrettier,
"
  fi

  config_content="${config_content}  {
    languageOptions: {
      globals: { ...globals.browser, ...globals.node },
    },
     rules: { 'vue/multi-word-component-names': 'off' },
  },
];
"
  echo "$config_content" > eslint.config.js

  if $USE_PRETTIER; then
    cat > .prettierrc <<EOF
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
EOF
  fi
}

write_tsconfig() {
  cat > tsconfig.json <<EOF
{
  "extends": "@vue/tsconfig/tsconfig.dom.json",
  "include": ["env.d.ts", "src/**/*", "src/**/*.vue"],
  "exclude": ["src/**/__tests__/*"],
  "compilerOptions": {
    "moduleResolution": "bundler",
    "tsBuildInfoFile": "./node_modules/.tmp/tsconfig.app.tsbuildinfo",
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
EOF
  cat > env.d.ts <<EOF
/// <reference types="vite/client" />
EOF
}

write_jsconfig() {
  cat > jsconfig.json <<EOF
{
  "compilerOptions": {
    "target": "esnext",
    "module": "esnext",
    "moduleResolution": "node",
    "strict": false,
    "jsx": "preserve",
    "sourceMap": true,
    "resolveJsonModule": true,
    "esModuleInterop": true,
    "lib": ["esnext", "dom"],
    "baseUrl": ".",
    "paths": { "@/*": ["src/*"] }
  },
  "include": ["src/**/*", "tests/**/*"],
  "exclude": ["node_modules", "dist"]
}
EOF
}

write_code_files() {
  log_info "Writing source files..."
  local ext="js"
  if $IS_TS; then ext="ts"; fi

  # index.html
  cat > index.html <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${PROJECT_NAME}</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.${ext}"></script>
  </body>
</html>
EOF

  # src/style.css
  if $USE_TAILWIND; then
      cat > src/style.css <<EOF
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --color-background: #ffffff;
    --color-text: #1a1a1a;
    --color-primary-50: #f0f9ff;
    --color-primary-100: #e0f2fe;
    --color-primary-500: #0ea5e9;
    --color-primary-600: #0284c7;
    --color-primary-900: #0c4a6e;
  }
}
EOF
  else
      cat > src/style.css <<EOF
:root {
  --color-background: #ffffff;
  --color-text: #1a1a1a;
  --color-primary-500: #0ea5e9;
  --color-primary-600: #0284c7;
}
body {
  font-family: system-ui, -apple-system, sans-serif;
  background-color: var(--color-background);
  color: var(--color-text);
  margin: 0;
}
EOF
  fi

  # src/main.ts/js
  local imports="import { createApp } from 'vue'
"
  local setups="const app = createApp(App)
"

  if $USE_PINIA; then 
    imports="${imports}import { createPinia } from 'pinia'
"
    setups="${setups}app.use(createPinia())
"
  fi
  
  imports="${imports}import App from './App.vue'
"
  
  if $USE_ROUTER; then
    imports="${imports}import router from './router'
"
    setups="${setups}app.use(router)
"
  fi
  
  imports="${imports}import './style.css'
"
  setups="${setups}app.mount('#app')"

  echo -e "$imports\n$setups" > "src/main.$ext"

  # src/App.vue
  if $USE_ROUTER; then
      cat > src/App.vue <<EOF
<script setup${IS_TS:+ lang="ts"}></script>
<template>
  <router-view />
</template>
EOF
  else
      cat > src/App.vue <<EOF
<script setup${IS_TS:+ lang="ts"}>
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import Home from '@/views/Home.vue'
</script>
<template>
  <DefaultLayout>
    <Home />
  </DefaultLayout>
</template>
EOF
  fi

  # src/router/index.ts/js
  if $USE_ROUTER; then
      local router_content=""
      if $IS_TS; then
        router_content="import { createRouter, createWebHistory } from 'vue-router'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import Home from '@/views/Home.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: DefaultLayout,
      children: [
        { path: '', name: 'home', component: Home }
      ]
    }
  ]
})
export default router"
      else
        router_content="import { createRouter, createWebHistory } from 'vue-router'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import Home from '@/views/Home.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: DefaultLayout,
      children: [
        { path: '', name: 'home', component: Home }
      ]
    }
  ]
})
export default router"
      fi
      
      echo "$router_content" > "src/router/index.$ext"
  fi

  # Components
  # Layout
  local header_class="p-4 border-b"
  local h1_class="text-xl font-bold"
  local footer_class="p-4 bg-gray-100 text-center text-sm"
  
  if $USE_TAILWIND; then
      h1_class="$h1_class text-primary-600"
      footer_class="$footer_class" # already good
  else
      h1_class=""
      header_class="padding: 1rem; border-bottom: 1px solid #eee;"
      footer_class="padding: 1rem; background: #f0f0f0; text-align: center;"
  fi

  # For non-tailwind, we invoke inline styles or simple classes if css defined
  # To keep it simple, if no tailwind, we used simple css in style.css.
  # Let's use classes assuming custom css covered basic things or just use inline for simplicity in "no tailwind" mode.
  
  cat > src/layouts/DefaultLayout.vue <<EOF
<script setup${IS_TS:+ lang="ts"}>
import Footer from '@/components/common/Footer.vue'
</script>
<template>
  <div class="min-h-screen flex flex-col">
    <header class="$header_class">
      <h1 class="$h1_class">${PROJECT_NAME}</h1>
    </header>
    <main class="flex-grow">
      <slot /> <!-- Allows usage as wrapper or with router -->
      ${USE_ROUTER:+<router-view />} 
    </main>
    <Footer />
  </div>
</template>
<style scoped>
/* Basic backup styles if no tailwind */
.flex { display: flex; }
.flex-col { flex-direction: column; }
.min-h-screen { min-height: 100vh; }
.flex-grow { flex-grow: 1; }
</style>
EOF
  # Note: The above slot/router logic might duplicate if I'm not careful.
  # If Router: App calls <router-view>, router loads DefaultLayout which calls <router-view> (if nested) or just Home.
  # In my router config: component: DefaultLayout, children: [Home]. So DefaultLayout needs <router-view>.
  # If No Router: App calls <DefaultLayout><Home/></DefaultLayout>. So DefaultLayout needs <slot/>.
  
  # Let's refine DefaultLayout:
  if $USE_ROUTER; then
    cat > src/layouts/DefaultLayout.vue <<EOF
<script setup${IS_TS:+ lang="ts"}>
import Footer from '@/components/common/Footer.vue'
</script>
<template>
  <div class="layout">
    <header class="header">
      <h1 class="title">${PROJECT_NAME}</h1>
    </header>
    <main class="main">
      <router-view />
    </main>
    <Footer />
  </div>
</template>
<style scoped>
/* Minimal styles compatible with or without Tailwind */
.layout { min-height: 100vh; display: flex; flex-direction: column; }
.header { padding: 1rem; border-bottom: 1px solid #eee; }
.title { font-weight: bold; font-size: 1.25rem; }
.main { flex-grow: 1; }
${USE_TAILWIND:+
.title { @apply text-primary-600; }
.header { @apply p-4; }
}
</style>
EOF
  else
    cat > src/layouts/DefaultLayout.vue <<EOF
<script setup${IS_TS:+ lang="ts"}>
import Footer from '@/components/common/Footer.vue'
</script>
<template>
  <div class="layout">
    <header class="header">
      <h1 class="title">${PROJECT_NAME}</h1>
    </header>
    <main class="main">
      <slot />
    </main>
    <Footer />
  </div>
</template>
<style scoped>
.layout { min-height: 100vh; display: flex; flex-direction: column; }
.header { padding: 1rem; border-bottom: 1px solid #eee; }
.title { font-weight: bold; font-size: 1.25rem; }
.main { flex-grow: 1; }
${USE_TAILWIND:+
.title { @apply text-primary-600; }
.header { @apply p-4; }
}
</style>
EOF
  fi
  # Note: Using @apply in style block is fine if postcss configured.
  # If no tailwind, those apply lines are invalid CSS. 
  # Actually, if I don't use tailwind, I shouldn't write @apply.
  # I'll stick to classes.
  
  # Footer
  cat > src/components/common/Footer.vue <<EOF
<template>
  <footer class="footer">
    &copy; {{ new Date().getFullYear() }} ${PROJECT_NAME}. All rights reserved.
  </footer>
</template>
<style scoped>
.footer { padding: 1rem; background-color: #f3f4f6; text-align: center; font-size: 0.875rem; }
</style>
EOF

  # Home View
  local script_setup=""
  local template_content=""
  
  if $USE_PINIA; then
    script_setup="import { useCounterStore } from '@/stores/counter'
const counter = useCounterStore()"
    template_content="    <div class=\"card\">
        <p class=\"mb-4\">Count: {{ counter.count }}</p>
        <button @click=\"counter.increment()\" class=\"btn\">Increment</button>
    </div>"
  else
    script_setup="import { ref } from 'vue'
const count = ref(0)
function increment() { count.value++ }"
    template_content="    <div class=\"card\">
        <p class=\"mb-4\">Count: {{ count }}</p>
        <button @click=\"increment()\" class=\"btn\">Increment</button>
    </div>"
  fi
  
  cat > src/views/Home.vue <<EOF
<script setup${IS_TS:+ lang="ts"}>
${script_setup}
</script>
<template>
  <div class="home">
    <h1 class="title">Welcome to ${PROJECT_NAME}</h1>
    <p class="subtitle">Modular Vue.js Architecture</p>
${template_content}
  </div>
</template>
<style scoped>
.home { padding: 2rem; max-width: 56rem; margin: 0 auto; text-align: center; }
.title { font-size: 2.25rem; font-weight: bold; margin-bottom: 1rem; color: #0284c7; }
.subtitle { font-size: 1.125rem; color: #374151; margin-bottom: 2rem; }
.card { padding: 1.5rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; background: white; display: inline-block; }
.btn { padding: 0.5rem 1rem; background-color: #0ea5e9; color: white; border-radius: 0.25rem; border: none; cursor: pointer; }
.btn:hover { background-color: #0284c7; }
.mb-4 { margin-bottom: 1rem; }
</style>
EOF

  # src/stores/counter.ts/js
  if $USE_PINIA; then
    if $IS_TS; then
      cat > src/stores/counter.ts <<EOF
import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', () => {
  const count = ref<number>(0)
  const doubleCount = computed(() => count.value * 2)
  function increment() { count.value++ }
  return { count, doubleCount, increment }
})
EOF
    else
      cat > src/stores/counter.js <<EOF
import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubleCount = computed(() => count.value * 2)
  function increment() { count.value++ }
  return { count, doubleCount, increment }
})
EOF
    fi
  fi

  # .editorconfig
  cat > .editorconfig <<EOF
root = true

[*]
charset = utf-8
indent_style = space
indent_size = 2
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false
EOF

  # Configs
  if $IS_TS; then write_tsconfig; else write_jsconfig; fi
}
