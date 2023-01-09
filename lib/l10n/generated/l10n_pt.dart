import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for Portuguese (`pt`).
class L10nPt extends L10n {
  L10nPt([String locale = 'pt']) : super(locale);

  @override
  String get my_title => 'Meu título aqui';

  @override
  String get logout => 'Sair';

  @override
  String get note => 'Nota';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sim';

  @override
  String get delete => 'Deletar';

  @override
  String get sharing => 'Compartilhar';

  @override
  String get ok => 'OK';

  @override
  String get login => 'Entrar';

  @override
  String get verify_email => 'Verifique seu email';

  @override
  String get register => 'Registre-se';

  @override
  String get restart => 'Recomeçar';

  @override
  String get start_typing_your_note => 'Comece a escrever aqui...';

  @override
  String get delete_note_prompt => 'Tem certeza que vai deletar essa nota?';

  @override
  String get cannot_share_empty_note_prompt => 'Não é possível compartilhar uma nota vazia!';

  @override
  String get generic_error_prompt => 'Ocorreu um erro';

  @override
  String get generic_error_unpredicted => 'Ocorreu um erro não previsto';

  @override
  String get logout_dialog_prompt => 'Tem certeza que quer sair?';

  @override
  String get password_reset => 'Resetar a senha';

  @override
  String get password_reset_dialog_prompt => 'Nós te enviamos um link de reset de senha. Por favor, verifique seu e-mail para mais informações.';

  @override
  String get login_error_cannot_find_user => 'Não foi possível achar um usuário com esses dados';

  @override
  String get login_error_wrong_credentials => 'Dados incorretos.';

  @override
  String get login_error_auth_error => 'Erro de autenticação';

  @override
  String get login_error_invalid_email => 'O e-mail que você inseriu parece inválido. Por favor, verifique e tente novamente!';

  @override
  String get login_view_prompt => 'Por favor entre com sua conta, para criar e editar suas anotações!';

  @override
  String get login_view_forgot_password => 'Esqueci a senha';

  @override
  String get login_view_not_registered_yet => 'Sem cadastro? Cadastre-se aqui!';

  @override
  String get email_text_field_placeholder => 'Insira seu e-mail aqui...';

  @override
  String get password_text_field_placeholder => 'Insira sua senha aqui...';

  @override
  String get forgot_password => 'Esqueci a senha';

  @override
  String get forgot_password_view_generic_error => 'Não conseguimos processar seu pedido. Por favor, tenha certeza que é um usuário registrado, caso não seja, cadastre-se agora voltando uma tela.';

  @override
  String get forgot_password_view_prompt => 'Se você esqueceu sua senha, entre com seu e-amil abaixo e lhe enviaremos um link de reset.';

  @override
  String get forgot_password_view_send_me_link => 'Me envie o link novamente';

  @override
  String get forgot_password_view_back_to_login => 'Voltar para o início';

  @override
  String get register_error_weak_password => 'Essa senha não é segura o suficiente. Por favor, escolha outra senha!';

  @override
  String get register_error_email_already_in_use => 'Esse e-mail já foi registrado por outro usuário. Por favor, escolha outro e-mail!';

  @override
  String get register_error_generic => 'O cadastro falhou. Por favor, tente novamente mais tarde!';

  @override
  String get register_error_invalid_email => 'O e-mail inserido parece inválido. Por favor, verifique e tente novamente!';

  @override
  String get register_view_prompt => 'Entre com seu e-mail e senha para acessar suas anotçaões!';

  @override
  String get register_view_already_registered => 'Já cadastrado? Entre aqui!';

  @override
  String get verify_email_view_prompt => 'Nós te enviamos um e-mail de verificação. Por favor, abra-o para verificar sua conta. Se você ainda não recebeu o e-mail, pressione o botão abaixo!';

  @override
  String get verify_email_send_email_verification => 'Enviar o e-mail de verificação';

  @override
  String notes_title(num count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      zero: 'Sem anotações, crie uma!',
      one: '1 Anotação',
      other: '$count Anotações',
    );
  }
}
