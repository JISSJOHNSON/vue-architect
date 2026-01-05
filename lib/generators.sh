#!/bin/bash

# Generates configuration files and source code based on selected features.

write_vite_config() {
  local ext="js"
  if $IS_TS; then ext="ts"; fi
  cp "$ARCHITECT_ROOT/resources/vue/vite.config.template" "vite.config.$ext"
}

write_tailwind_config() {
  if ! $USE_TAILWIND; then return; fi
  cp "$ARCHITECT_ROOT/resources/vue/tailwind.config.template" "tailwind.config.js"
  cp "$ARCHITECT_ROOT/resources/vue/postcss.config.template" "postcss.config.js"
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
  cp "$ARCHITECT_ROOT/resources/vue/tsconfig.json.template" "tsconfig.json"
  cat > env.d.ts <<EOF
/// <reference types="vite/client" />
EOF
}

write_jsconfig() {
  cp "$ARCHITECT_ROOT/resources/vue/jsconfig.json.template" "jsconfig.json"
}

write_code_files() {
  log_info "Writing professional source files..."
  local ext="js"
  if $IS_TS; then ext="ts"; fi

  local v_res="$ARCHITECT_ROOT/resources/vue"
  local app_lang=""
  if $IS_TS; then app_lang=' lang="ts"'; fi

  # .env & .env.example
  generate_from_template "$v_res/.env.template" ".env" "PROJECT_NAME" "$PROJECT_NAME"
  cp ".env" ".env.example"

  # index.html
  generate_from_template "$v_res/index.html.template" "index.html" \
    "PROJECT_NAME" "$PROJECT_NAME" \
    "EXT" "$ext"

  # Constants
  generate_from_template "$v_res/src/constants/index.template" "src/constants/index.$ext"

  # Helpers
  # Storage Helper
  generate_from_template "$v_res/src/helpers/storage.helper.template" "src/helpers/storage.helper.$ext"

  # Format Helper (with conditional library logic)
  local date_import=""
  local date_logic="return new Date(date).toLocaleDateString()"
  if $USE_DATE_LIB; then
    date_import="import { format } from 'date-fns'"
    date_logic="return format(new Date(date), pattern)"
  fi

  local num_import=""
  local num_logic="return number.toLocaleString()"
  if $USE_NUMBER_LIB; then
    num_import="import numeral from 'numeral'"
    num_logic="return numeral(number).format(pattern)"
  fi

  generate_from_template "$v_res/src/helpers/format.helper.template" "src/helpers/format.helper.$ext" \
    "DATE_IMPORT" "$date_import" \
    "DATE_FORMAT_LOGIC" "$date_logic" \
    "NUMBER_IMPORT" "$num_import" \
    "NUMBER_FORMAT_LOGIC" "$num_logic"

  # API & Services
  generate_from_template "$v_res/src/api/index.template" "src/api/index.$ext"
  generate_from_template "$v_res/src/services/user.service.template" "src/services/user.service.$ext"

  # Styles
  generate_from_template "$v_res/src/assets/styles/main.css.template" "src/assets/styles/main.css"

  # Main Entry
  local router_import=""
  local router_use=""
  if $USE_ROUTER; then
    router_import="import router from './router'"
    router_use="app.use(router)"
  fi

  local pinia_import=""
  local pinia_use=""
  if $USE_PINIA; then
    pinia_import="import { createPinia } from 'pinia'"
    pinia_use="app.use(createPinia())"
  fi

  generate_from_template "$v_res/src/main.template" "src/main.$ext" \
    "ROUTER_IMPORT" "$router_import" \
    "ROUTER_USE" "$router_use" \
    "PINIA_IMPORT" "$pinia_import" \
    "PINIA_USE" "$pinia_use"

  # App Entry
  local app_script=""
  local app_template=""
  if $USE_ROUTER; then
    app_script="import { useRoute } from 'vue-router'\nimport MainLayout from '@/layouts/MainLayout.vue'\n\nconst route = useRoute()"
    app_template="  <component :is=\"route.meta.layout || MainLayout\">\n    <router-view />\n  </component>"
  else
    app_script="import MainLayout from '@/layouts/MainLayout.vue'\nimport Home from '@/views/Home.vue'"
    app_template="  <MainLayout>\n    <Home />\n  </MainLayout>"
  fi

  generate_from_template "$v_res/src/App.vue.template" "src/App.vue" \
    "LANG" "$app_lang" \
    "SCRIPT_CONTENT" "$(echo -e "$app_script")" \
    "TEMPLATE_CONTENT" "$(echo -e "$app_template")"

  # Components
  generate_from_template "$v_res/src/components/base/BaseButton.vue.template" "src/components/base/BaseButton.vue" "LANG" "$app_lang"
  
  local brand_link="<a href=\"/\" class=\"brand\">$PROJECT_NAME</a>"
  local nav_links_html="<a href=\"/\" class=\"nav-link\">Home</a>\n        <a href=\"/about\" class=\"nav-link\">About</a>"
  
  if $USE_ROUTER; then
    brand_link="<router-link to=\"/\" class=\"brand\">$PROJECT_NAME</router-link>"
    nav_links_html="<router-link v-for=\"item in navItems\" :key=\"item.path\" :to=\"item.path\" class=\"nav-link\">{{ item.name }}</router-link>"
  fi

  generate_from_template "$v_res/src/components/common/Navbar.vue.template" "src/components/common/Navbar.vue" \
    "LANG" "$app_lang" \
    "PROJECT_NAME" "$PROJECT_NAME" \
    "BRAND_LINK" "$brand_link" \
    "NAV_LINKS" "$(echo -e "$nav_links_html")"
  generate_from_template "$v_res/src/components/common/Footer.vue.template" "src/components/common/Footer.vue" \
    "PROJECT_NAME" "$PROJECT_NAME" \
    "YEAR" "$(date +%Y)"

  # Layouts
  local layout_content="<slot />"
  if $USE_ROUTER; then layout_content="<router-view />"; fi
  generate_from_template "$v_res/src/layouts/MainLayout.vue.template" "src/layouts/MainLayout.vue" \
    "LANG" "$app_lang" \
    "CONTENT" "$layout_content"

  # Router
  generate_from_template "$v_res/src/router/guards/auth.guard.template" "src/router/guards/auth.guard.$ext"
  cp "$v_res/src/router/index.template" "src/router/index.$ext"

  # Views (Home, About, NotFound)
  local home_script=""
  local home_template=""
  
  if $USE_PINIA; then
    home_script="import { useCounterStore } from '@/stores/counter'\nconst counter = useCounterStore()"
    home_template="    <div class=\"card\">\n        <p class=\"mb-4\">Count: {{ counter.count }}</p>\n        <BaseButton @click=\"counter.increment()\">Increment</BaseButton>\n    </div>"
  else
    home_script="import { ref } from 'vue'\nconst count = ref(0)\nfunction increment() { count.value++ }"
    home_template="    <div class=\"card\">\n        <p class=\"mb-4\">Count: {{ count }}</p>\n        <BaseButton @click=\"increment()\">Increment</BaseButton>\n    </div>"
  fi
  
  generate_from_template "$v_res/src/views/Home.vue.template" "src/views/Home.vue" \
    "LANG" "$app_lang" \
    "PROJECT_NAME" "$PROJECT_NAME" \
    "SCRIPT_SETUP" "$(echo -e "$home_script")" \
    "TEMPLATE_CONTENT" "$(echo -e "$home_template")"

  generate_from_template "$v_res/src/views/About.vue.template" "src/views/About.vue" "LANG" "$app_lang" "PROJECT_NAME" "$PROJECT_NAME"
  generate_from_template "$v_res/src/views/NotFound.vue.template" "src/views/NotFound.vue" "LANG" "$app_lang"

  # Pinia Store
  if $USE_PINIA; then
    local count_type=""
    if $IS_TS; then count_type="<number>"; fi
    generate_from_template "$v_res/src/stores/counter.template" "src/stores/counter.$ext" \
      "COUNT_TYPE" "$count_type"
  fi

  # Utility sample
  echo "export const formatDate = (date) => new Date(date).toLocaleDateString()" > "src/utils/index.$ext"

  # README
  # Remove the generated README.md if it exists from initializations
  rm -f README.md
  generate_from_template "$v_res/README.md.template" "README.md" "PROJECT_NAME" "$PROJECT_NAME"

  # .editorconfig
  cp "$v_res/.editorconfig.template" ".editorconfig"

  # Configs
  if $IS_TS; then write_tsconfig; else write_jsconfig; fi
}
