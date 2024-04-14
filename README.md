<h1>ZooTopic</h1>
<p>ZooTopic automatically collects content from various news sources and delivers it to users. This service provides up-to-date news, trends, and important event information quickly, helping users save time and effort.</p>

<h1>System Configuration</h1><br>

<h2>Data Crawling:</h2>
<p>Python: Uses Python along with libraries like Pandas to automatically collect data from various news sources. These tools are powerful for parsing HTML from web pages and extracting necessary data.</p>

<h2>Data Processing and Storage:</h2>
<p>AWS Lambda: Implements serverless functions to process and refine crawled data. Lambda operates on an event-driven basis and is triggered after the crawling process to automate the workflow.</p>
<p>AWS S3: Safely stores the refined data. S3 provides high durability and is ideal for backing up and archiving crawled news data.</p>

<h2>Email and Event Scheduling:</h2>
<p>Amazon EventBridge: Sets up event scheduling to send emails to subscribers every morning at 6 AM. EventBridge manages integration with AWS services and automates workflows based on events.</p>
<p>Amazon SES (Simple Email Service): Implements a service to send news summaries via email to subscribers. SES allows for the reliable dispatch of bulk emails and also provides related email sending statistics.</p>
<p>Amazon SQS: Uses SQS to manage and buffer email data to be sent via SES. SQS is a messaging queuing service that can handle and manage large volumes of messages reliably.</p>

<h2>Security and Performance Optimization:</h2>
<p>Amazon Route 53: Provides Domain Name System (DNS) services to manage the website’s domain and optimize traffic routing.</p>
<p>Amazon CloudFront: A Content Delivery Network (CDN) service that provides fast loading speeds to users worldwide, useful for efficiently distributing both static and dynamic web content.</p>
<p>AWS WAF: Provides a web application firewall to protect the website from security threats. WAF detects and blocks attacks, enhancing the stability and security of the website.</p>

<h2>Revenue Model</h2>
<p>Subscription Service: Users can subscribe on a monthly or annual basis via the website. Subscribers receive summarized news in their email every morning at 6 AM, offering a more in-depth and ad-free experience compared to regular free content.</p>
<p>This system provides a technologically sophisticated yet user-friendly service, representing a modern way to consume news content. Additionally, by leveraging the robust cloud infrastructure of AWS, it enables a scalable and easily manageable system.</p>


<h1>Architecture</h1>
<img src="image.png" alt="This is an image" />

<br><br>

<h1>ZooTopic</h1>
<p>ZooTopic은 다양한 뉴스 소스에서 자동으로 콘텐츠를 수집(크롤링)하여 사용자에게 제공하는 웹사이트입니다. 이 서비스는 최신 뉴스, 트렌드, 중요 이벤트에 대한 정보를 신속하게 제공함으로써 사용자가 시간과 노력을 절약할 수 있도록 돕습니다.</p>

<h1>시스템 구성</h1><br>

<h2>데이터 크롤링:</h2>
<p>Python: Python과 함께 Pandas 같은 라이브러리를 사용하여 다양한 뉴스 소스에서 데이터를 자동으로 수집합니다. 이러한 도구는 웹 페이지의 HTML을 파싱하고 필요한 데이터를 추출하는 데 강력합니다.</p>

<h2>데이터 처리 및 저장:</h2>
<p>AWS Lambda: 크롤링된 데이터를 처리하고 정제하는 서버리스 함수를 구현합니다. Lambda는 이벤트 기반으로 작동하며, 크롤링 작업 완료 후 트리거되어 처리 과정을 자동화합니다.</p>
<p>AWS S3: 정제된 데이터를 안전하게 저장하기 위한 객체 스토리지 서비스입니다. S3는 높은 내구성을 제공하며 크롤링된 뉴스 데이터의 백업 및 아카이빙에 이상적입니다.</p>

<h2>이메일 및 이벤트 스케줄링:</h2>
<p>Amazon EventBridge: 구독자에게 매일 아침 6시에 이메일을 보내기 위한 이벤트 스케줄링을 설정합니다. EventBridge는 이벤트 기반의 AWS 서비스와의 통합을 관리하여 자동화된 작업 흐름을 가능하게 합니다.</p>
<p>Amazon SES (Simple Email Service): 구독자에게 뉴스 요약을 이메일로 전송하는 서비스를 구현합니다. SES를 사용하면 대량의 이메일을 안정적으로 발송할 수 있으며, 이메일 전송 관련 통계도 제공받을 수 있습니다.</p>
<p>Amazon SQS: SES를 통해 발송될 이메일 데이터를 관리하고 버퍼링하기 위해 SQS를 사용합니다. SQS는 메시지 큐잉 서비스로, 대량의 메시지를 안정적으로 전달하고 관리할 수 있습니다.</p>

<h2>보안 및 성능 최적화:</h2>
<p>Amazon Route 53: 도메인 이름 시스템(DNS) 서비스를 제공하여 웹사이트의 도메인을 관리하고 트래픽 라우팅을 최적화합니다.</p>
<p>Amazon CloudFront: 콘텐츠 전송 네트워크(CDN) 서비스를 사용하여 전 세계 사용자에게 빠른 콘텐츠 로딩 속도를 제공합니다. 이는 정적 및 동적 웹 콘텐츠를 효율적으로 배포하는 데 유용합니다.</p>
<p>AWS WAF: 웹 애플리케이션 방화벽을 제공하여 웹사이트를 보안 위협으로부터 보호합니다. WAF는 공격을 탐지하고 차단하여 웹사이트의 안정성과 보안을 강화합니다.</p>

<h2>수익 모델</h2>
<p>구독 서비스: 사용자는 웹사이트에서 월별 또는 연간 구독을 신청할 수 있습니다. 구독자는 매일 아침 6시에 요약된 뉴스를 이메일로 받게 되며, 이는 일반적인 무료 콘텐츠보다 더 심층적이고 광고가 없는 경험을 제공할 수 있습니다.</p>
<p>이러한 시스템은 기술적으로 세련되면서도 사용자에게 매우 편리한 서비스를 제공하는 방식으로, 뉴스 콘텐츠를 소비하는 현대적인 방법을 대변합니다. 또한, AWS의 강력한 클라우드 인프라를 활용함으로써 확장성이 뛰어나고 관리가 용이한 시스템을 구축할 수 있습니다.</p>
