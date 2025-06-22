// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get title => 'Cartan';

  @override
  String get cards => 'Cartões';

  @override
  String get empty_cards => 'Ainda não tens cartões associados';

  @override
  String get add => 'Adicionar';

  @override
  String get help => 'Ajuda';

  @override
  String get settings => 'Definições';

  @override
  String get success => 'Operação realizada com sucesso!';

  @override
  String get error => 'Ocorreu um erro ao processar a sua solicitação.';

  @override
  String get close => 'Fechar';

  @override
  String get language => 'Idioma';

  @override
  String get dark_mode => 'Modo escuro';

  @override
  String get font_size => 'Tamanho da letra';

  @override
  String get terms_and_conditions => 'Termos e condições';

  @override
  String get terms_and_conditions_url =>
      'https://firebasestorage.googleapis.com/v0/b/cartan-a6680.firebasestorage.app/o/pt%2Fterms_conditions.html?alt=media';

  @override
  String get privacy_policy => 'Política de privacidade';

  @override
  String get privacy_policy_url =>
      'https://firebasestorage.googleapis.com/v0/b/cartan-a6680.firebasestorage.app/o/pt%2Fprivacy_policy.html?alt=media';

  @override
  String get feedback => 'Feedback';

  @override
  String get large_font => 'Grande';

  @override
  String get normal_font => 'Normal';

  @override
  String get small_font => 'Pequena';

  @override
  String get select_merchant => 'Selecionar loja';

  @override
  String get scan_barcode => 'Digitalizar código';

  @override
  String get enter_manually => 'Inserir manualmente';

  @override
  String get position_barcode_in_frame =>
      'Posicione o código de barras dentro da moldura';

  @override
  String get scanning_hint =>
      'Certifique-se de que o código de barras está bem iluminado e claramente visível';

  @override
  String get card_number => 'Número do cartão';

  @override
  String get add_card => 'Adicionar cartão';

  @override
  String get format_hint =>
      'Insira o número mostrado no seu cartão de fidelidade';

  @override
  String get invalid_card_format => 'Formato de cartão inválido';

  @override
  String get card_added_successfully => 'Cartão adicionado com sucesso';

  @override
  String get barcode => 'Código de barras';

  @override
  String get qr_code => 'QR Code';

  @override
  String get zoom => 'Ampliar';

  @override
  String get back => 'Voltar';

  @override
  String get nearest_places => 'Locais mais próximos';

  @override
  String get website => 'Website';

  @override
  String get remove => 'Remover';

  @override
  String get confirm_delete => 'Eliminar cartão';

  @override
  String get confirm_delete_message =>
      'Tem a certeza de que pretende remover este cartão? Esta ação não pode ser anulada.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get card_deleted_successfully => 'Cartão eliminado com sucesso.';

  @override
  String get error_deleting_card => 'Ocorreu um erro ao eliminar o cartão.';

  @override
  String get no_map_apps_installed => 'Nenhuma aplicação de mapas instalada';

  @override
  String get search => 'Procurar';

  @override
  String get camera_permission_required =>
      'É necessário dar acesso à câmara para ler o seu cartão.';

  @override
  String get open_settings => 'Abrir definições da aplicação';

  @override
  String get digits => 'dígitos';

  @override
  String get name => 'Nome';

  @override
  String get email => 'Email';

  @override
  String get message => 'Mensagem';

  @override
  String get submit => 'Submeter feedback';

  @override
  String get feedback_sent => 'Obrigado pelo seu feedback!';

  @override
  String get name_required => 'O nome é obrigatório.';

  @override
  String get email_required => 'O e-mail é obrigatório.';

  @override
  String get invalid_email => 'Por favor, insira um endereço de e-mail válido.';

  @override
  String get message_required => 'Por favor, escreva a sua mensagem.';

  @override
  String get feedback_submission_error =>
      'Não foi possível enviar a sua mensagem. Tente novamente mais tarde.';

  @override
  String get card_already_exists =>
      'Já existe um cartão deste comerciante com esse número.';

  @override
  String get no_results_found => 'Sem resultados';

  @override
  String get invalid_card_not_empty_alphanumeric =>
      'Campo alfanumérico e não pode estar vazio.';
}
