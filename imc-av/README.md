# 📱 Calculadora de IMC — Flutter App

Aplicativo Flutter para cálculo do Índice de Massa Corporal (IMC) com interface moderna e responsiva.

---

## ✨ Funcionalidades

- ✅ Campos para Peso (kg) e Altura (m)
- ✅ Botão "Calcular IMC" com validação via `Form` + `TextFormField`
- ✅ Exibição do valor do IMC com 2 casas decimais
- ✅ Classificação do IMC com cor correspondente
- ✅ Tabela de referência interativa (destaca a categoria atual)
- ✅ Botão "Limpar" campos após o cálculo
- ✅ Mensagens de erro com `SnackBar`
- ✅ Animação de entrada no resultado (fade + slide)
- ✅ Layout responsivo (mobile e desktop/web)

---

## 🚀 Como rodar

### Pré-requisitos
- [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado
- VS Code com extensão Flutter **ou** Android Studio

### Passos

```bash
# 1. Acesse a pasta do projeto
cd imc_app

# 2. Instale as dependências
flutter pub get

# 3. Rode no navegador (web)
flutter run -d chrome

# 4. Rode no emulador/dispositivo
flutter run

# 5. Build para web (produção)
flutter build web
```

---

## 🌐 Testando online (sem instalar Flutter)

Use o [DartPad](https://dartpad.dev) — suporta Flutter Web:

1. Acesse [dartpad.dev](https://dartpad.dev)
2. Clique em **New Pad** → selecione **Flutter**
3. Apague o código padrão
4. Cole o conteúdo de `lib/main.dart`
5. Clique em **Run** ▶️

---

## 📐 Classificação do IMC

| Faixa        | Classificação     |
|:-------------|:------------------|
| < 18,5       | Abaixo do peso    |
| 18,5 – 24,9  | Peso normal       |
| 25,0 – 29,9  | Sobrepeso         |
| ≥ 30,0       | Obesidade         |

---

## 🗂️ Estrutura do Projeto

```
imc_app/
├── lib/
│   └── main.dart          # Código principal do app
├── pubspec.yaml           # Dependências e configurações
├── analysis_options.yaml  # Regras de linting
└── README.md              # Este arquivo
```

---

## 🛠️ Tecnologias usadas

- **Flutter 3.x** com Material Design 3
- `StatefulWidget` + `setState()`
- `TextFormField` com validação via `Form`
- `TextEditingController`
- `ElevatedButton` / `OutlinedButton`
- `SnackBar` para erros
- `AnimationController` para animações de resultado
- Layout responsivo com `ConstrainedBox` + breakpoints
