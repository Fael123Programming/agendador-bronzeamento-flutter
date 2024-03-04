import 'package:agendador_bronzeamento/utils/sender.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_text/styled_text.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(context) {
    RxBool pinkBox = false.obs;
    RxBool showPrivacy = false.obs;
    RxBool showUse = false.obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Meu Bronze',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'DancingScript'
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Text(
                'v1.0.26',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  fontStyle: FontStyle.italic
                ),
              )
            ),
            GestureDetector(
              onTapDown: (details) => pinkBox.value = true,
              onTapUp: (details) => pinkBox.value = false,
              child: Obx(() => Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: pinkBox.value ? Colors.pink : Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                // color: Colors.white,
                child: const Image(
                  image: AssetImage('assets/tanning.png'),
                  width: 80,
                  height: 80,
                ),
              )),
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: const Text('Este é um aplicativo criado para facilitar a gestão de macas e clientes em centros de estética, oferecendo controle total de temporizadores para as macas, barras de pesquisa de clientes e relatório de bronzeamentos feitos.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      side: BorderSide(color: Colors.white),
                    ),
                    onTap: () => showPrivacy.value = !showPrivacy.value,
                    hoverColor: Colors.pink[100],
                    tileColor: Colors.pink,
                    title: const Text(
                      'Política de Privacidade',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Obx(() => Icon(
                      showPrivacy.value ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
                    )),
                  ),
                ),
                Obx(() => showPrivacy.value ? Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        'Política de Privacidade', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(30),
                      child: const Text(
                        'O aplicativo móvel para centros de estética ("Meu Bronze") é desenvolvido e mantido por Rafael Guimarães. Esta política de privacidade descreve como o Aplicativo coleta, utiliza e protege as informações pessoais dos usuários.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 10, left: 20),
                      child: const Text(
                        '1. Informações Coletadas', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'O Aplicativo coleta as seguintes informações pessoais dos usuários:',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18
                        ),
                        text: '<bold>\u2022 Nome:</bold> Para identificar e personalizar a experiência do usuário;',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        text: '<bold>\u2022 Telefone:</bold> Para entrar em contato com o usuário para confirmação de agendamentos, lembretes de compromissos ou para fornecer informações relevantes sobre os serviços do centro de estética;',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        text: '<bold>\u2022 Observações de Saúde:</bold> Opcionalmente, o usuário pode fornecer observações sobre sua saúde para auxiliar no atendimento e na prestação de serviços adequados.',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '2. Uso das Informações', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'As informações coletadas são utilizadas para os seguintes propósitos:',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18
                        ),
                        text: '<bold>\u2022</bold> Facilitar o agendamento de serviços de estética;',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        text: '<bold>\u2022</bold> Personalizar a experiência do usuário dentro do Aplicativo;',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        text: '<bold>\u2022</bold> Entrar em contato com o usuário para confirmar agendamentos ou fornecer informações relevantes sobre os serviços;',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        text: '<bold>\u2022</bold> Melhorar os serviços oferecidos pelo centro de estética.',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '3. Compartilhamento de Informações', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'As informações pessoais dos usuários não serão compartilhadas, vendidas ou alugadas a terceiros, exceto nos seguintes casos:',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18
                        ),
                        text: '<bold>\u2022</bold> Quando necessário para cumprir com obrigações legais;',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18
                        ),
                        text: '<bold>\u2022</bold> Com consentimento explícito do usuário.',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '4. Proteção de Dados', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'O Aplicativo emprega medidas de segurança adequadas para proteger as informações pessoais dos usuários contra acesso não autorizado, alteração, divulgação ou destruição. Isso inclui o uso de protocolos de criptografia para proteger dados sensíveis durante a transmissão.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '5. Direitos do Usuário', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'Os usuários têm o direito de acessar, corrigir, atualizar ou excluir suas informações pessoais armazenadas no Aplicativo. Para exercer esses direitos ou para obter mais informações sobre como suas informações são tratadas, os usuários podem entrar em contato conosco utilizando os detalhes fornecidos abaixo.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '6. Alterações na Política de Privacidade', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'Esta política de privacidade pode ser atualizada periodicamente para refletir mudanças nas práticas de coleta e uso de informações. Recomenda-se que os usuários revisem esta política regularmente para estar cientes de quaisquer alterações.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '7. Contato', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const Text(
                            'Se os usuários tiverem dúvidas ou preocupações sobre esta política de privacidade ou sobre o uso de suas informações pessoais, eles podem entrar em contato conosco através do seguinte endereço de e-mail:',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => sendMail('Suporte para Meu Bronze', 'Olá, sou cliente do App Meu Bronze e estou precisando de suporte! Pode me ajudar?'),
                            child: const Text(
                              'rafaelfonseca1020@gmail.com.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'Ao usar o Aplicativo, os usuários concordam com os termos desta política de privacidade e com o processamento de suas informações pessoais conforme descrito aqui.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'Data de entrada em vigor: 04 de Março de 2024.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ) : Container())
              ],
            ),
            const Divider(height: 0),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      side: BorderSide(color: Colors.white),
                    ),
                    onTap: () => showUse.value = !showUse.value,
                    hoverColor: Colors.pink[100],
                    tileColor: Colors.pink,
                    title: const Text(
                      'Política de Uso',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Obx(() => Icon(
                      showUse.value ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
                    )),
                  ),
                ),
                Obx(() => showUse.value ? Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        'Política de Uso', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(30),
                      child: const Text(
                        'Bem-vindo ao aplicativo móvel para centros de estética ("Meu Bronze"). Esta política de uso descreve as condições e diretrizes para o uso do Aplicativo por empresárias de centros de estética.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 10, left: 20),
                      child: const Text(
                        '1. Elegibilidade', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'O Aplicativo destina-se exclusivamente a empresárias de centros de estética que desejam utilizar suas funcionalidades para ajudar no gerenciamento das macas e das informações das clientes.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '2. Uso Adequado', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'As usuárias do Aplicativo concordam em utilizá-lo de forma ética e responsável. Isso inclui:',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18
                        ),
                        text: '<bold>\u2022</bold> Utilizar as funcionalidades do Aplicativo apenas para fins relacionados à gestão de macas e informações das clientes nos seus centros de estética;',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        text: '<bold>\u2022</bold> Não compartilhar suas credenciais de acesso ao Aplicativo com terceiros;',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: StyledText(
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        text: '<bold>\u2022</bold> Não utilizar o Aplicativo para atividades ilegais ou antiéticas.',
                        tags: {
                          'bold': StyledTextTag(
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                            ),
                        },
                      )
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '3. Responsabilidade pelas Informações', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'As usuárias são responsáveis por todas as informações fornecidas e gerenciadas através do Aplicativo, incluindo as informações das clientes. Elas concordam em manter essas informações precisas, atualizadas e protegidas contra acesso não autorizado.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '4. Uso de Recursos do Dispositivo', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'As usuárias concordam em utilizar os recursos do dispositivo móvel de forma apropriada ao utilizar o Aplicativo. Isso inclui garantir que o dispositivo tenha memória e bateria suficientes para operar o Aplicativo de forma eficaz.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '5. Atualizações do Aplicativo', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'As usuárias concordam em manter o Aplicativo atualizado, instalando as atualizações disponibilizadas pela empresa desenvolvedora. Isso garante o bom funcionamento do Aplicativo e a segurança das informações armazenadas.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '6. Feedback e Suporte', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'As usuárias são encorajadas a fornecer feedback sobre o Aplicativo e a relatar quaisquer problemas ou dificuldades encontradas durante o uso. O desenvolvedor fornecerá suporte técnico e assistência sempre que necessário.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '7. Alterações na Política de Uso', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'Esta política de uso pode ser atualizada periodicamente para refletir mudanças nas condições de uso do Aplicativo. As usuárias serão notificadas sobre quaisquer alterações significativas na política de uso.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 30, left: 20),
                      child: const Text(
                        '8. Contato', 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ), 
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const Text(
                            'Se as usuárias tiverem dúvidas ou preocupações sobre esta política de uso, elas podem entrar em contato conosco através do seguinte endereço de e-mail:',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => sendMail('Suporte para Meu Bronze', 'Olá, sou cliente do App Meu Bronze e estou precisando de suporte! Pode me ajudar?'),
                            child: const Text(
                              'rafaelfonseca1020@gmail.com.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'Ao utilizar o Aplicativo, as usuárias concordam com os termos desta política de uso e comprometem-se a utilizá-lo de acordo com as diretrizes estabelecidas.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: const Text(
                        'Data de entrada em vigor: 04 de Março de 2024.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),      
                    ],
                ) : Container())
              ],
            ),
          ]
        ),
      ),
    );
  }
}